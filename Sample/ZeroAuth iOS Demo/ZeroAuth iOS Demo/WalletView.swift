import SwiftUI
import Suiness
import ZeroAuthCore
import ZeroAuth
import Alamofire

struct WalletView: View {
    @ObservedObject var viewModel: WalletViewModel
    
    var body: some View {
        VStack {
            Text("Account")
                .font(.title)
                .padding(.top, 50)
            
            Text(viewModel.accountAddress)
                .font(.body)
                .padding()
                .background(Color.purple.opacity(0.2))
                .cornerRadius(8)
                .padding(.bottom, 20)
            
            Text("Balance: \(viewModel.balance) SUI")
                .font(.title3)
                .padding(.bottom, 40)
            
            Button(action: {
                viewModel.sendAction()
            }) {
                Text("Send")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PurpleButtonStyle())
            
            Button(action: {
                viewModel.requestTestTokens()
            }) {
                Text("Request Test Tokens")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PurpleButtonStyle())
            .padding(.top, 10)
            
            Spacer()
            
            Button(action: {
                viewModel.logOut()
            }) {
                Text("Log Out")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PurpleButtonStyle())
            .padding(.bottom, 50)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PurpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(30)
            .padding(.horizontal)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

class WalletViewModel: ObservableObject {
    
    @Published var accountAddress: String = ""
    
    @Published var balance: Int64 = 0
    
    @Published var zkLoginResponse: ZKLoginResponse?
    
    @Published var model: ZKLoginModel
    
    init(model: ZKLoginModel) {
        self.model = model
        self.zkLoginResponse = model.response
        if zkLoginResponse != nil {
            self.accountAddress = zkLoginResponse?.address ?? ""
        }
        fetchAccountBalance()
    }
    
    func sendAction() {}
    
    func requestTestTokens() {
        let url = "https://faucet.devnet.sui.io/gas"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "FixedAmountRequest": [
                "recipient": "\(accountAddress)"
            ]
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let transferredGasObjects = json["transferredGasObjects"] as? [[String: Any]] {
                    for gasObject in transferredGasObjects {
                        let amount = gasObject["amount"] as? Int64 ?? 0
                        let id = gasObject["id"] as? String ?? ""
                        let transferTxDigest = gasObject["transferTxDigest"] as? String ?? ""
                        Logger.debug(data: "Test Tokens allocated: Amount: \(amount), ID: \(id), Transfer Transaction Digest: \(transferTxDigest)")
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
    }
    
    
    
    func fetchAccountBalance() {
        let urlString = "https://sui-devnet.mystenlabs.com/graphql"
        guard let url = URL(string: urlString) else { return }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        
        let parameters: Parameters = [
            "query": "query { address(address: \"\(accountAddress)\") { balance { totalBalance } } }"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { [weak self] response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let data = json["data"] as? [String: Any],
                       let address = data["address"] as? [String: Any],
                       let balance = address["balance"] as? [String: Any],
                       let totalBalanceString = balance["totalBalance"] as? String {
                        let totalBalance = Int64(totalBalanceString) ?? 0
                        self?.balance = totalBalance / 1000000000
                    } else {
                        self?.balance = 0
                        Logger.debug(data: "Balance is null or could not be fetched")
                        print()
                    }
                case .failure(let error):
                    Logger.debug(data: error.localizedDescription)
                }
            }
        }
        
        
    }
    
    
    func logOut() {
        model.getAuthenticatedViewModel()?.startLogout()
    }
}

struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView(viewModel: WalletViewModel(model: ZKLoginModel()))
    }
}
