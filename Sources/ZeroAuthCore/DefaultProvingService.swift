import Foundation
import Alamofire

/**This is the default proving service implementation. If a custom proving service implementation is not provided, this will be used. */
public struct DefaultProvingService : ProvingServiceProtocol {
    /** These are the default prover services taht ship with ZeroAuth. The testnet and mainnet prover require the calling clientId to be whitelisted. Contact Mysten Labs for more info*/
    public static let MYSTEN_TESTNET_PROVER_URL = "https://prover.mystenlabs.com/v1"
    public static let MYSTEN_MAINNET_PROVER_URL = "https://prover.mystenlabs.com/v1"
    public static let MYSTEN_DEVNET_PROVER_URL = "https://prover-dev.mystenlabs.com/v1"
    
    public var prover = MYSTEN_DEVNET_PROVER_URL
    
    public var proof = ""
    
    public init(prover: String = "") {
        self.prover = prover
    }
    
    public func fetchProof(jwtToken: String, extendedEphemeralPublicKey: String, maxEpoch: Int64, randomness: String, salt: String) async throws -> Proof {
        return try await withCheckedThrowingContinuation { continuation in
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let parameters: Parameters = [
                "jwt": jwtToken,
                "extendedEphemeralPublicKey": extendedEphemeralPublicKey,
                "maxEpoch": "\(maxEpoch)",
                "jwtRandomness": randomness,
                "salt": salt,
                "keyClaimName": "sub"
            ]
            
            AF.request(prover, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let proofResponse = try decoder.decode(Proof.self, from: data)
                        continuation.resume(returning: proofResponse)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
