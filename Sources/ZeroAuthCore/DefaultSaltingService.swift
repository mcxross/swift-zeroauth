public struct DefaultSaltingService : SaltingServiceProtocol {
   
    public var salt: String = ""
    
    public init() {}

    public func getSalt(jwt: String) async throws -> String {
        return self.salt
    }
    
}
