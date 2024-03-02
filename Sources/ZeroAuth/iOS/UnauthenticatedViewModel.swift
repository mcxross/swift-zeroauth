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
                    
                    let updatedNonce = Nonce(endPoint: userNonce.endPoint, pubKey: userNonce.pubKey,  maxEpoch: UInt64(epochId) + userNonce.maxEpoch, randomness: userNonce.randomness)
                    
                    let userOIDSC = zkLoginRequest.openIDServiceConfiguration
                    
                    let oidsc = OpenIDServiceConfiguration(provider: userOIDSC.provider, clientId: userOIDSC.clientId, redirectUri: userOIDSC.redirectUri, nonce: updatedNonce)
                    
                    let updatedZKLoginRequest = ZKLoginRequest(openIDServiceConfiguration: oidsc, saltingService: zkLoginRequest.saltingService)
                    
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
                        
                        
                        await MainActor.run {
                            
                            let additionalParams = authorizationResponse?.additionalParameters
                            
                            let response = ZKLoginResponse(tokenInfo: TokenInfo(accessToken: authorizationResponse?.accessToken, expiresIn: 5, refreshToken: tokenResponse.refreshToken, scope: authorizationResponse?.scope, tokenType: authorizationResponse?.tokenType, idToken: tokenResponse.idToken,
                                                                                nonce: additionalParams?["nonce"] as? String),
                                                           saltingService: updatedZKLoginRequest.saltingService)
                            
                            
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
}
