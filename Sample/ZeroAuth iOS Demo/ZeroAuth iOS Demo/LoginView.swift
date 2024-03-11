import SwiftUI
import ZeroAuthCore
import ZeroAuth

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
   
    var body: some View {
        VStack {
            Text("Access Sui")
                .font(.largeTitle)
                .padding(.bottom, 50)
            
            Button(action: {
                viewModel.loginGoogle()
            }) {
                HStack {
                    Text("Login with Google").foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            Button(action: {
                viewModel.loginApple()
            }) {
                HStack {
                    Text("Login with Apple").foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray)
                .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            Button(action: {}) {
                HStack {
                    Text("Login with Facebook").foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            Button(action: {}) {
                HStack {
                    Text("Login with Slack").foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple)
                .cornerRadius(10)
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, 10)
    }
}

class LoginViewModel: ObservableObject {
    
    @Published var model: ZKLoginModel
    private var unauthModel: UnauthenticatedViewModel
    
    init(model: ZKLoginModel) {
        self.model = model
        self.unauthModel = model.getUnauthenticatedViewModel()
    }
    
    func loginGoogle() {
        let req = ZKLoginRequest(
            openIDServiceConfiguration: OpenIDServiceConfiguration(provider: Google(), clientId: "284882057281-fgsdehdsd6ivlduhsmllvlc1973nkuj3.apps.googleusercontent.com",
                                                                   redirectUri: "com.googleusercontent.apps.284882057281-fgsdehdsd6ivlduhsmllvlc1973nkuj3:/oauth2redirect/google"),
            saltingService: DefaultSaltingService())
        
        unauthModel.zkLogin(zkLoginRequest: req)
    }
    
    
    func loginApple() {
        let req = ZKLoginRequest(openIDServiceConfiguration: OpenIDServiceConfiguration(provider: Apple(), clientId: "284882057281-fgsdehdsd6ivlduhsmllvlc1973nkuj3.apps.googleusercontent.com",
                                                                                        redirectUri: "com.googleusercontent.apps.284882057281-fgsdehdsd6ivlduhsmllvlc1973nkuj3:/oauth2redirect/google"))
        unauthModel.zkLogin(zkLoginRequest: req)
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
      let model = ZKLoginModel()
        LoginView(viewModel: LoginViewModel(model: model))
    }
}
