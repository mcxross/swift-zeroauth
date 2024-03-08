public protocol SaltingServiceProtocol {
    var salt: String { get set }
    func fetchSalt(jwt: String) async throws -> String
}
