import Suiness

public struct Nonce {
    public var endPoint: String
    public var pubKey: String
    public var maxEpoch: UInt64
    public var randomness: String
    
    public init(endPoint: String = "https://sui-testnet.mystenlabs.com", pubKey: String = "", maxEpoch: UInt64 = 30, randomness: String = generateRandomness()) {
        self.endPoint = endPoint
        self.pubKey = pubKey
        self.maxEpoch = maxEpoch
        self.randomness = randomness
    }
    
    // Computed property to generate a string representation of the Nonce
    public var value: String? {
        do {
            let keyToUse: String
            if pubKey.isEmpty {
                let derivedKey = try deriveNewKey().address
                keyToUse = derivedKey
            } else {
                keyToUse = pubKey
            }
            return try generateNonce(pk: keyToUse, maxEpoch: self.maxEpoch, randomness: self.randomness)
        } catch {
            return nil
        }
    }

}

