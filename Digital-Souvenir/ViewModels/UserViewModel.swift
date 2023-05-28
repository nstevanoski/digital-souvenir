import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class UserViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var showingAlert : Bool = false
    @Published var alertMessage = ""
    @Published var alertTitle = ""
        
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    var uuid: String? {
        return auth.currentUser?.uid
    }
    
    var userIsAuthenticated: Bool {
        return auth.currentUser != nil
    }
    
    var userIsAuthenticatedAndSynced: Bool {
        return user != nil && userIsAuthenticated
    }
    
    var userIsAnonymous: Bool{
        return auth.currentUser?.email == nil
    }
    
    func updateAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showingAlert = true
    }

    func signUp(email: String, password: String, username: String) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.updateAlert(title: "Error", message: error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.addUser(User(username: username, signUpDate: Date.now, userEmail: email))
                    self.syncUser()
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            }
        }
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.updateAlert(title: "Error", message: error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.syncUser()
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            }
        }
    }
    
    func signInWithGoogle(from viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            guard error == nil else {
                // Handle the error.
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // Handle the missing user or ID token.
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    self.updateAlert(title: "Error", message: error.localizedDescription)
                } else {
                    if let userEmail = result?.user.email {
                        self.addUser(User(username: userEmail, signUpDate: Date.now, userEmail: userEmail))
                    }

                    DispatchQueue.main.async {
                        self.syncUser()
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    }
                }
            }
        }
    }
    
    func signInWithFacebook() {
        let loginManager = LoginManager()
                
        loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { (result, error) in
            if let error = error {
                print("Facebook login failed with error: \(error.localizedDescription)")
                return
            }
                    
            guard let result = result, !result.isCancelled else {
                print("Facebook login was canceled.")
                return
            }
                    
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    self.updateAlert(title: "Error", message: error.localizedDescription)
                } else {
                    if let userEmail = result?.user.email {
                        self.addUser(User(username: userEmail, signUpDate: Date.now, userEmail: userEmail))
                    }

                    DispatchQueue.main.async {
                        self.syncUser()
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    }
                }
            }
        }
    }
    
    func signInAnonymously() {
        auth.signInAnonymously() { authResult, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.addUser(User(username: "guest", signUpDate: Date.now, userEmail: "guest"))
                    self.syncUser()
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            } else {
                self.updateAlert(title: "Error", message: error?.localizedDescription ?? "Coś poszło nie tak")
            }
        }
    }
    
    func resetPassword(email: String) {
        auth.sendPasswordReset(withEmail: email) { error in
            if error == nil {
                self.updateAlert(title: "Success", message: "A password change link has been sent to your e-mail address.")
            } else {
                self.updateAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong!")
            }
        }
    }


    func signOut(){
        do{
            try auth.signOut()
            self.user = nil
            UserDefaults.standard.set(false, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
        }
        catch{
            print("Error signing out user: \(error)")
        }
    }
    
    //MARK: firestore functions for user data
    
    func syncUser(){
        guard userIsAuthenticated else { return }
        db.collection("Users").document(self.uuid!).getDocument { document, error in
            guard document != nil, error == nil else { return }
            do{
                try self.user = document!.data(as: User.self)
            } catch{
                print("sync error: \(error)")
            }
        }
    }
    
    private func addUser(_ user: User){
        guard userIsAuthenticated else { return }
        do {
            let _ = try db.collection("Users").document(self.uuid!).setData(from: user)

        } catch {
            print("Error adding: \(error)")
        }
    }
    
    private func update(){
        guard userIsAuthenticatedAndSynced else { return }
        do{
            let _ = try db.collection("Users").document(self.uuid!).setData(from: user)
        } catch{
            print("error updating \(error)")
        }
        
    }
    
    func changePassword(email: String, currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void){
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        auth.currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                completion(error)
            } else {
                self.auth.currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    completion(error)
                })
            }
        })
    }
}
