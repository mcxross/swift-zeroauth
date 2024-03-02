public struct TokenInfo {
    public let accessToken: String?
    public let expiresIn: Int
    public let refreshToken: String?
    public let scope: String?
    public let tokenType: String?
    public let idToken: String?
    public let nonce: String?
    
    public init(accessToken: String?, expiresIn: Int, refreshToken: String?, scope: String?, tokenType: String?, idToken: String?, nonce: String?) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.refreshToken = refreshToken
        self.scope = scope
        self.tokenType = tokenType
        self.idToken = idToken
        self.nonce = nonce
    }
    
}
