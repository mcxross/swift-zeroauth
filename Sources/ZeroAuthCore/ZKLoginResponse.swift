public struct ZKLoginResponse {
    public let address: String
    public let tokenInfo: TokenInfo
    public let saltinService: SaltingServiceProtocol
    
    public init(address: String, tokenInfo: TokenInfo, saltingService: SaltingServiceProtocol) {
        self.address = address
        self.tokenInfo = tokenInfo
        self.saltinService = saltingService
    }
}
