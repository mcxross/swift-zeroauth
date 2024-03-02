public struct ZKLoginRequest {
    public let openIDServiceConfiguration: OpenIDServiceConfiguration
    public let saltingService: SaltingServiceProtocol
    public init(openIDServiceConfiguration: OpenIDServiceConfiguration,
                saltingService: SaltingServiceProtocol = DefaultSaltingService()) {
        self.openIDServiceConfiguration = openIDServiceConfiguration
        self.saltingService = saltingService
    }
}
