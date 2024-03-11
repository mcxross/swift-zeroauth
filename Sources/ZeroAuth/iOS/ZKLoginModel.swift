import Foundation
import ZeroAuthCore

@available(iOS 15.0, *)
public class ZKLoginModel : ObservableObject {
    
    private var unauthenticatedModel: UnauthenticatedViewModel?
    private var authenticatedModel: AuthenticatedViewModel?
    
    @Published public var response: ZKLoginResponse? = nil
    
    public init() {
        self.unauthenticatedModel = nil
        self.authenticatedModel = nil
    }
    
    public func getUnauthenticatedViewModel() -> UnauthenticatedViewModel {
        
        if self.unauthenticatedModel == nil {
            self.unauthenticatedModel = UnauthenticatedViewModel(
                onLoggedIn: self.onLoggedIn)
        }
        
        return self.unauthenticatedModel!
    }
    
    public func getAuthenticatedViewModel() -> AuthenticatedViewModel? {
            guard let response = self.response else {
                return nil
            }
            
            if self.authenticatedModel == nil {
                self.authenticatedModel = AuthenticatedViewModel(zkLoginResponse: response, onLoggedOut: self.onLoggedOut)
            }
            return self.authenticatedModel
        }
    
    func onLoggedIn(zkLoginResponse: ZKLoginResponse?) {
        self.response = zkLoginResponse
    }
    
    func onLoggedOut() {
           self.response = nil
    }
    
}
