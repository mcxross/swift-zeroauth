import Foundation
import ZeroAuthCore

class ZKLoginModel : ObservableObject {
    
    private var unauthenticatedModel: UnauthenticatedViewModel?
    
    @Published var response: ZKLoginResponse? = nil
    
    init() {
        self.unauthenticatedModel = nil
    }
    
    func getUnauthenticatedViewModel() -> UnauthenticatedViewModel {
        
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
