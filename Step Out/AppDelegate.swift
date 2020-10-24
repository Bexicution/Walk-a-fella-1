import Firebase
import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    var username: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.clientID = "273121369071-i2lph2nq4srqjra8ttrj9k0j8t93e80e.apps.googleusercontent.com"
        coordinateRouting()
        return true
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)		
        } else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { [weak self] (result, error) in
                guard let self = self else { return }
                if error == nil {
                    self.username = result?.user.displayName
                    self.coordinateRouting()
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    private func coordinateRouting() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if (Auth.auth().currentUser != nil) {
            print("\(Auth.auth()) KEKS1")
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LeaderboardViewController") as! LeaderboardViewController
            
        } else {
            print("\(Auth.auth()) KEKS2")
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        }
        
        window?.makeKeyAndVisible()
    }
}
