public struct OpenIDServiceConfiguration {
    public let provider: Provider
    public let clientId: String
    public let redirectUri: String
    public let nonce: Nonce
    
    public init(provider: Provider,
                clientId: String,
                redirectUri: String,
                nonce: Nonce? = nil) {
        self.provider = provider
        self.clientId = clientId
        self.redirectUri = redirectUri
        if let givenNonce = nonce {
             self.nonce = givenNonce
         } else {
                    do {
                        // Try to generate a new Nonce
                        self.nonce = try Nonce()
                    } catch {
                        // Handle the error or provide a fallback mechanism
                        fatalError("Failed to generate Nonce: \(error)")
                        // Alternatively, you could also initialize `nonce` with some default state that represents a failed generation.
                        // But, using `fatalError` here to highlight the failure explicitly.
                    }
                }
    }
}
