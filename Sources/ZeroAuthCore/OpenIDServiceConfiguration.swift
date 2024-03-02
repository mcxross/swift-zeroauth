public struct OpenIDServiceConfiguration {
    public let provider: Provider
    public let clientId: String
    public let redirectUri: String
    public let nonce: Nonce
    
    public init(provider: Provider,
                clientId: String,
                redirectUri: String,
                nonce: Nonce = Nonce()) {
        self.provider = provider
        self.clientId = clientId
        self.redirectUri = redirectUri
        self.nonce = nonce
    }
}
