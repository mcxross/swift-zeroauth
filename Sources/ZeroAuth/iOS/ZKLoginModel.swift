import Foundation
import ZeroAuthCore

@available(iOS 13.0, *)
public class ZKLoginModel : ObservableObject {
    
    private var unauthenticatedModel: UnauthenticatedViewModel?
    
    @Published public var response: ZKLoginResponse? = nil
    
    public init() {
        self.unauthenticatedModel = nil
    }
    
    public func getUnauthenticatedViewModel() -> UnauthenticatedViewModel {
        
        if self.unauthenticatedModel == nil {
            self.unauthenticatedModel = UnauthenticatedViewModel(
                onLoggedIn: self.onLoggedIn)
        }
        
        return self.unauthenticatedModel!
    }
    
    func onLoggedIn(zkLoginResponse: ZKLoginResponse?) {
        self.response = zkLoginResponse
    }
    
}
