public struct DefaultSaltingService : SaltingServiceProtocol {
   
    public var salt: String = "129390038577185583942388216820280642146"
    
    public init() {}

    public func fetchSalt(jwt: String) async throws -> String {
        return self.salt
    }
    
}
