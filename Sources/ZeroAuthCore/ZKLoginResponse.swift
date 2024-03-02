public struct ZKLoginResponse {
    public let tokenInfo: TokenInfo
    public let saltinService: SaltingServiceProtocol
    
    public init(tokenInfo: TokenInfo, saltingService: SaltingServiceProtocol) {
        self.tokenInfo = tokenInfo
        self.saltinService = saltingService
    }
}
