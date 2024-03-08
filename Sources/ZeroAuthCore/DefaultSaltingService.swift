public struct DefaultSaltingService : SaltingServiceProtocol {
   
    public var salt: String = ""
    public var jwt: String
    
    public init(jwt: String) {
        self.jwt = jwt
    }

    public func getSalt() async throws -> String {
        return self.salt
    }
    
}
