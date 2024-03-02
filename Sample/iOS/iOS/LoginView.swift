import SwiftUI
import ZeroAuthCore
import ZeroAuth

struct LoginView: View {
    private var model: UnauthenticatedViewModel
    
    init(
        model: UnauthenticatedViewModel
    ) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            Text("Access Sui")
                .font(.largeTitle)
                .padding(.bottom, 50)
            
            Button(action: {
                let google = ZKLoginRequest(
                    openIDServiceConfiguration: OpenIDServiceConfiguration(provider: Google(), clientId: "284882057281-fgsdehdsd6ivlduhsmllvlc1973nkuj3.apps.googleusercontent.com",
                                                                           redirectUri: "com.googleusercontent.apps.284882057281-fgsdehdsd6ivlduhsmllvlc1973nkuj3:/oauth2redirect/google"),
                    saltingService: DefaultSaltingService(salt: "129390038577185583942388216820280642146"))
                
                model.zkLogin(zkLoginRequest: google)
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
            
            Button(action: {}) {
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
    @Published var success: Bool = false
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let model = UnauthenticatedViewModel(onLoggedIn: {response in})
        LoginView(model: model)
    }
}
