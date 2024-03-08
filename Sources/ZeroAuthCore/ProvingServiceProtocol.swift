public protocol ProvingServiceProtocol {
    var proof: String { get set }
    func fetchProof(jwtToken: String, extendedEphemeralPublicKey: String, maxEpoch: Int64, randomness: String, salt: String) async throws -> Proof
}
