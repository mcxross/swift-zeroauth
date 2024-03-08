public protocol SaltingServiceProtocol {
    var salt: String { get set }
    func getSalt() async throws -> String
}
