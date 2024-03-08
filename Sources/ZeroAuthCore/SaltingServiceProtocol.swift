public protocol SaltingServiceProtocol {
    var salt: String { get set }
    func getSalt(jwt: String) async throws -> String
}
