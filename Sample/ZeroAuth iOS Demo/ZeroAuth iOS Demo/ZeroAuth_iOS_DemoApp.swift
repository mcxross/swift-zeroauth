import SwiftUI
import ZeroAuth

@main
struct ZeroAuth_iOS_DemoApp: App {
    @ObservedObject private var model: ZKLoginModel
    
    init() {
        self.model = ZKLoginModel()
    }
    
    var body: some Scene {
        WindowGroup {
            if model.response != nil {
                WalletView(viewModel: WalletViewModel(response: model.response!))
            } else {
                LoginView(model: model.getUnauthenticatedViewModel())
            }
        }
    }
}
