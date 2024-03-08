public struct DefaultSaltingService : SaltingServiceProtocol {
   
    public var salt: String
    
    public init(salt: String = "") {
        self.salt = salt
    }

    public func getSalt() async throws -> String {
        return self.salt
    }
    
}
