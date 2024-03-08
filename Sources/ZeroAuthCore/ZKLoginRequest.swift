public struct ZKLoginRequest {
    public let openIDServiceConfiguration: OpenIDServiceConfiguration
    public let saltingService: SaltingServiceProtocol
    public let provingService: ProvingServiceProtocol
    public init(openIDServiceConfiguration: OpenIDServiceConfiguration,
                saltingService: SaltingServiceProtocol = DefaultSaltingService(),
                provingService: ProvingServiceProtocol = DefaultProvingService()) {
        self.openIDServiceConfiguration = openIDServiceConfiguration
        self.saltingService = saltingService
        self.provingService = provingService
    }
}
