public struct ZKLoginResponse {
    public let address: String
    public let kp: Keypair
    public let tokenInfo: TokenInfo
    public let salt: String
    public let proof: Proof
    
    public init(
        address: String,
        kp: Keypair,
        tokenInfo: TokenInfo,
        salt: String,
        proof: Proof
    ) {
        self.address = address
        self.kp = kp
        self.tokenInfo = tokenInfo
        self.salt = salt
        self.proof = proof
    }
}
