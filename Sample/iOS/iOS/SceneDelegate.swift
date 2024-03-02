import UIKit
import AppAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("Here...")
        guard let url = URLContexts.first?.url else {
            return
        }

        // Assuming `AppDelegate` holds the currentAuthorizationFlow reference
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let authFlow = appDelegate.currentAuthorizationFlow,
           authFlow.resumeExternalUserAgentFlow(with: url) {
            appDelegate.currentAuthorizationFlow = nil
        }
    }

}
