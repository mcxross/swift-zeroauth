import Foundation
import Alamofire

// This is a simple Sui Client that does only one thing, get the current epoch.
public struct SuiClient {
    
    public var endPoint: String
    
    let graphqlQuery: Parameters = [
        "query": """
        query {
          epoch {
            epochId
          }
        }
        """
    ]
    
    public init(endPoint: String = "https://sui-testnet.mystenlabs.com") {
        self.endPoint = if endPoint.isEmpty {
            "https://sui-testnet.mystenlabs.com"
        } else {
            endPoint
        }
    }
    
    public func getSuiCurrentEpoch() async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            AF.request(endPoint, method: .post, parameters: graphqlQuery, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let data = json["data"] as? [String: Any],
                       let epoch = data["epoch"] as? [String: Any],
                       let epochId = epoch["epochId"] as? Int {
                        continuation.resume(returning: epochId)
                    } else {
                        continuation.resume(throwing: NSError(domain: "DataParsingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Epoch ID not found or invalid format"]))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
