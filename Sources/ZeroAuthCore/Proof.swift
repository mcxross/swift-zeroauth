import Foundation

public struct Proof: Codable {
    public let proofPoints: ProofPoints
    public let issBase64Details: IssBase64Details
    public let headerBase64: String
    
    public init(proofPoints: ProofPoints, issBase64Details: IssBase64Details, headerBase64: String) {
        self.proofPoints = proofPoints
        self.issBase64Details = issBase64Details
        self.headerBase64 = headerBase64
    }
    
    func toJsonString() -> String? {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            do {
                let data = try encoder.encode(self)
                return String(data: data, encoding: .utf8)
            } catch {
                print("Error converting ProofResponse to JSON string: \(error)")
                return nil
            }
        }
    
}

public struct ProofPoints: Codable {
    public let a: [String]
    public let b: [[String]]
    public let c: [String]
}

public struct IssBase64Details: Codable {
    public let value: String
    public let indexMod4: Int
}
