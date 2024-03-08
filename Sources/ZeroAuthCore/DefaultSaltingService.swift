public struct DefaultSaltingService : SaltingServiceProtocol {
   
    public var salt: String = "129390038577185583942388216820280642146"
    public var jwt: String
    
    public init(jwt: String) {
        self.jwt = jwt
    }

    public func getSalt() async throws -> String {
        return self.salt
    }
    
}
