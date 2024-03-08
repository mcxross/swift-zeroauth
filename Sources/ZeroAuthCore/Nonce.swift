import Suiness

public struct Nonce {
    public var endPoint: String
    public var kp: Keypair
    public var maxEpoch: UInt64
    public var randomness: String
    
    public init(endPoint: String = "https://sui-testnet.mystenlabs.com", kp: Keypair = Keypair(), maxEpoch: UInt64 = 30, randomness: String = generateRandomness()) {
        self.endPoint = endPoint
        self.kp = kp
        self.maxEpoch = maxEpoch
        self.randomness = randomness
    }
    
    // Computed property to generate a string representation of the Nonce
    public var value: String? {
        do {
            let kpToUse: Keypair
            if kp.pk.isEmpty || kp.sk.isEmpty {
                let derivedKey = try deriveNewKey()
                kpToUse = Keypair(sk: derivedKey.sk, pk: derivedKey.address)
            } else {
                kpToUse = kp
            }
            return try generateNonce(pk: kpToUse.pk, maxEpoch: self.maxEpoch, randomness: self.randomness)
        } catch {
            return nil
        }
    }

}

