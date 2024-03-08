public struct Keypair {
    public let sk: String
    public let pk: String
   
    public init(sk: String = "", pk: String = "") {
        self.sk = sk
        self.pk = pk
    }
}
