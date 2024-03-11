import Suiness

public enum NonceError: Error {
    case keypairGenerationFailed
}


public struct Nonce {
    public var endPoint: String
    public var kp: Keypair
    public var maxEpoch: UInt64
    public var randomness: String
    
    public init(endPoint: String = "https://sui-devnet.mystenlabs.com", kp: Keypair? = nil, maxEpoch: UInt64 = 30, randomness: String = generateRandomness()) throws {
        self.endPoint = endPoint
        self.maxEpoch = maxEpoch
        self.randomness = randomness
        
        if let providedKp = kp, !providedKp.pk.isEmpty, !providedKp.sk.isEmpty {
                    self.kp = providedKp
                } else {
                    do {
                        let generatedKeypair = try deriveNewKey()
                        self.kp = Keypair(sk: generatedKeypair.sk, pk: generatedKeypair.address)
                    } catch {
                        throw NonceError.keypairGenerationFailed
                    }
      }
        
    }
    
    // Computed property to generate a string representation of the Nonce
    public var value: String? {
        do {
            return try generateNonce(sk: kp.sk, maxEpoch: self.maxEpoch, randomness: self.randomness)
        } catch {
            return nil
        }
    }

}

