public class ApplicationError: Error {
    
    public var title: String
    public var description: String
    
    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}
