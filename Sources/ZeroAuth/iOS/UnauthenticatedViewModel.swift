import Foundation
import AppAuth
import ZeroAuthCore
import Suiness

@available(iOS 13.0, *)
public class UnauthenticatedViewModel: ObservableObject {
    
    
    private let appauth: AppAuthHandler
    private let onLoggedIn: (ZKLoginResponse?) -> Void
    
    @Published var error: ApplicationError?
    
    public init(onLoggedIn: @escaping (ZKLoginResponse?) -> Void) {
        self.appauth = AppAuthHandler()
        self.onLoggedIn = onLoggedIn
        self.error = nil
    }
    
    /*
     * Run front channel operations on the UI thread and back channel operations on a background thread
     */
    public func zkLogin(
        zkLoginRequest: ZKLoginRequest) {
            Task {
                
                do {
                    
                    let epochId = try await SuiClient(endPoint: zkLoginRequest.openIDServiceConfiguration.nonce.endPoint).getSuiCurrentEpoch()
                    
                    let userNonce = zkLoginRequest.openIDServiceConfiguration.nonce
                    
                    let updatedNonce = Nonce(endPoint: userNonce.endPoint, kp: userNonce.kp,  maxEpoch: UInt64(epochId) + userNonce.maxEpoch, randomness: userNonce.randomness)
                    
                    let userOIDSC = zkLoginRequest.openIDServiceConfiguration
                    
                    let oidsc = OpenIDServiceConfiguration(provider: userOIDSC.provider, clientId: userOIDSC.clientId, redirectUri: userOIDSC.redirectUri, nonce: updatedNonce)
                    
                    let updatedZKLoginRequest = ZKLoginRequest(openIDServiceConfiguration: oidsc, saltingService: zkLoginRequest.saltingService, provingService: zkLoginRequest.provingService)
                    
                    // Initiate the redirect on the UI thread
                    try await MainActor.run {
                        
                        self.error = nil
                        try self.appauth.performAuthorizationRedirect(
                            zkLoginRequest: updatedZKLoginRequest,
                            viewController: self.getViewController()
                        )
                    }
                    
                    // Wait for the response
                    let authorizationResponse = try await self.appauth.handleAuthorizationResponse()
                    if authorizationResponse != nil {
                        
                        // Redeem the code for tokens
                        let tokenResponse = try await self.appauth.redeemCodeForTokens(
                            clientID: updatedZKLoginRequest.openIDServiceConfiguration.clientId,
                            authResponse: authorizationResponse!)
                        
                        print(tokenResponse)
                        
                        let salt = try await updatedZKLoginRequest.saltingService.fetchSalt(jwt: authorizationResponse?.accessToken ?? "")
                        
                        print(salt)
                        
                        let proofResponse = try await updatedZKLoginRequest.provingService.fetchProof(jwtToken: authorizationResponse?.accessToken ?? "", extendedEphemeralPublicKey: getExtendedEphemeralPublicKey(sk: updatedNonce.kp.pk), maxEpoch: Int64(updatedNonce.maxEpoch), randomness: updatedNonce.randomness, salt: salt)
                        
                        print(proofResponse)
                        
                        await MainActor.run {
                            
                           let additionalParams = authorizationResponse?.additionalParameters
                            
                           let tokenInfo = TokenInfo(accessToken: authorizationResponse?.accessToken, expiresIn: 5, refreshToken: tokenResponse.refreshToken, scope: authorizationResponse?.scope, tokenType: authorizationResponse?.tokenType, idToken: tokenResponse.idToken,
                                                                                nonce: additionalParams?["nonce"] as? String)
                            
                            let response = ZKLoginResponse(address: generateAddress(zkLoginRequest: updatedZKLoginRequest, tokenInfo: tokenInfo), kp: updatedZKLoginRequest.openIDServiceConfiguration.nonce.kp, tokenInfo: tokenInfo,
                                                           salt: salt,
                            proof: proofResponse)
                            
                            self.onLoggedIn(response)
                        }
                    }
                    
                } catch {
                    
                    // Handle errors on the UI thread
                    await MainActor.run {
                        let appError = error as? ApplicationError
                        if appError != nil {
                            self.error = appError!
                        }
                    }
                }
            }
        }
    
    private func getViewController() -> UIViewController {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if #available(iOS 15.0, *) {
            return scene!.keyWindow!.rootViewController!
        } else {
            return UIApplication.shared.windows.first!.rootViewController!
        }
    }
    
    func generateAddress(zkLoginRequest: ZKLoginRequest, tokenInfo: TokenInfo?) -> String {
       
        let reqProvider = zkLoginRequest.openIDServiceConfiguration.provider
        let provider: OidcProvider = determineProvider(reqProvider)
        
        if (tokenInfo?.idToken == nil) {
            return ""
        }
        
        if zkLoginRequest.saltingService.salt.isEmpty {
            return ""
        }
        
        return try! generateZkLoginAddress(provider: provider, jwt: (tokenInfo?.idToken)!, salt: zkLoginRequest.saltingService.salt)
    }

    private func determineProvider(_ reqProvider: Any) -> OidcProvider {
        if reqProvider is Google {
            return .google
        } else if reqProvider is Apple {
            return .apple
        } else if reqProvider is Facebook {
            return .facebook
        } else if reqProvider is Slack {
            return .slack
        } else {
            return .twitch
        }
    }

    
}
