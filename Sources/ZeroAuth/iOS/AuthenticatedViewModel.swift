import Foundation
import AppAuth
import ZeroAuthCore


@available(iOS 15.0, *)
public class AuthenticatedViewModel: ObservableObject {
    
    private let appauth: AppAuthHandler
    
    private let zkLoginResponse: ZKLoginResponse
    
    private let onLoggedOut: (() -> Void)
    
    init(zkLoginResponse: ZKLoginResponse, onLoggedOut: @escaping () -> Void){
        self.appauth = AppAuthHandler()
        self.zkLoginResponse = zkLoginResponse
        self.onLoggedOut = onLoggedOut
    }
    
    public func startLogout() {
        Task {

                    do {

                        try await MainActor.run {

                            try self.appauth.performEndSessionRedirect(
                                zkLoginResponse: zkLoginResponse,
                                viewController: self.getViewController()
                            )
                        }
                        
                        let _ = try await self.appauth.handleEndSessionResponse()

                        await MainActor.run {
                            self.onLoggedOut()
                        }

                    } catch {
                                        await MainActor.run {
                                            let appError = error as? ApplicationError
                                            if appError != nil {
                                                Logger.error(data: "An error occured...")
                                            }
                                        }
                                    }
                                }
    }
    
    
    @available(iOS 15.0, *)
    private func getViewController() -> UIViewController {
      let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
      return scene!.keyWindow!.rootViewController!
    }
}
