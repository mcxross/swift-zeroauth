import SwiftUI
import ZeroAuth

@main
struct ZeroAuth_iOS_DemoApp: App {
    @ObservedObject private var zkLModel: ZKLoginModel
    
    init() {
        self.zkLModel = ZKLoginModel()
    }
    
    var body: some Scene {
        WindowGroup {
            if zkLModel.response != nil {
                WalletView(viewModel: WalletViewModel(model: zkLModel))
            } else {
                LoginView(viewModel: LoginViewModel(model: zkLModel))
            }
        }
    }
}
