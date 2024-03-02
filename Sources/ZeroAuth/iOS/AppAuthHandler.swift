import AppAuth
import ZeroAuthCore

@available(iOS 13.0, *)
class AppAuthHandler {
    
    private var userAgentSession: OIDExternalUserAgentSession?
    private var loginResponseHandler: LoginResponseHandler?
    
    init() {
        self.userAgentSession = nil
    }
    
    func performAuthorizationRedirect(
        zkLoginRequest: ZKLoginRequest,
        viewController: UIViewController
    ) throws {
        
        guard let authorizationEndpoint = URL(string: zkLoginRequest.openIDServiceConfiguration.provider.authorizationEndpoint),
              let tokenEndpoint = URL(string: zkLoginRequest.openIDServiceConfiguration.provider.tokenEndpoint) else {
            Logger.error(data: "Invalid URL(s)")
            return
        }
        
        let configuration = OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint, tokenEndpoint: tokenEndpoint)
        
        guard let redirectURI = URL(string: zkLoginRequest.openIDServiceConfiguration.redirectUri) else {
            Logger.error(data: "Invalid redirect URI")
            return
        }
        
        guard let nonce = zkLoginRequest.openIDServiceConfiguration.nonce.value else {
            Logger.error(data: "Nonce can not be null")
            return
        }
        
        let state = OIDAuthorizationRequest.generateState()
        let codeVerifier = OIDAuthorizationRequest.generateCodeVerifier()
        let codeChallenge = OIDAuthorizationRequest.codeChallengeS256(forVerifier: codeVerifier)
        let codeChallengeMethod = OIDOAuthorizationRequestCodeChallengeMethodS256
        
        
        let request = OIDAuthorizationRequest(
            configuration: configuration,
            clientId: zkLoginRequest.openIDServiceConfiguration.clientId,
            clientSecret: nil,
            scope: "openid",
            redirectURL: redirectURI,
            responseType: OIDResponseTypeCode,
            state: state,
            nonce: nonce,
            codeVerifier: codeVerifier,
            codeChallenge: codeChallenge,
            codeChallengeMethod: codeChallengeMethod,
            additionalParameters: nil)
        
        let userAgent = OIDExternalUserAgentIOS(presenting: viewController)
        self.loginResponseHandler = LoginResponseHandler()
        self.userAgentSession = OIDAuthorizationService.present(
            request,
            externalUserAgent: userAgent!,
            callback: self.loginResponseHandler!.callback)
    }
    
    func handleAuthorizationResponse() async throws -> OIDAuthorizationResponse? {
        
        do {
            
            let response = try await self.loginResponseHandler!.waitForCallback()
            self.loginResponseHandler = nil
            return response
            
        } catch {
            
            self.loginResponseHandler = nil
            if (self.isUserCancellationErrorCode(ex: error)) {
                return nil
            }
            
            throw self.createAuthorizationError(title: "Authorization Request Error", ex: error)
        }
    }
    
    /*
     * Handle the authorization response, including the user closing the Chrome Custom Tab
     */
    func redeemCodeForTokens(clientID: String, authResponse: OIDAuthorizationResponse) async throws -> OIDTokenResponse {
        
        try await withCheckedThrowingContinuation { continuation in
            
            let extraParams = [String: String]()
            let request = authResponse.tokenExchangeRequest(withAdditionalParameters: extraParams)
            
            OIDAuthorizationService.perform(
                request!,
                originalAuthorizationResponse: authResponse) { tokenResponse, ex in
                    
                    if tokenResponse != nil {
                        let accessToken = tokenResponse!.accessToken == nil ? "" : tokenResponse!.accessToken!
                        let refreshToken = tokenResponse!.refreshToken == nil ? "" : tokenResponse!.refreshToken!
                        let idToken = tokenResponse!.idToken == nil ? "" : tokenResponse!.idToken
                        
                        continuation.resume(returning: tokenResponse!)
                        
                    } else {
                        
                        let error = self.createAuthorizationError(title: "Authorization Response Error", ex: ex)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    /*
     * We can check for specific error codes to handle the user cancelling the ASWebAuthenticationSession window
     */
    private func isUserCancellationErrorCode(ex: Error) -> Bool {
        
        let error = ex as NSError
        return error.domain == OIDGeneralErrorDomain && error.code == OIDErrorCode.userCanceledAuthorizationFlow.rawValue
    }
    
    /*
     * We can check for a specific error code when the refresh token expires and the user needs to re-authenticate
     */
    private func isRefreshTokenExpiredErrorCode(ex: Error) -> Bool {
        
        let error = ex as NSError
        return error.domain == OIDOAuthTokenErrorDomain && error.code == OIDErrorCodeOAuth.invalidGrant.rawValue
    }
    
    /*
     * Process standard OAuth error / error_description fields and also AppAuth error identifiers
     */
    private func createAuthorizationError(title: String, ex: Error?) -> ApplicationError {
        
        var parts = [String]()
        if (ex == nil) {
            
            parts.append("Unknown Error")
            
        } else {
            
            let nsError = ex! as NSError
            
            if nsError.domain.contains("org.openid.appauth") {
                parts.append("(\(nsError.domain) / \(String(nsError.code)))")
            }
            
            if !ex!.localizedDescription.isEmpty {
                parts.append(ex!.localizedDescription)
            }
        }
        
        let fullDescription = parts.joined(separator: " : ")
        let error = ApplicationError(title: title, description: fullDescription)
        Logger.error(data: "\(error.title) : \(error.description)")
        return error
    }
}
