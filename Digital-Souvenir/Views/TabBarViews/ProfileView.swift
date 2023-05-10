import SwiftUI
import Firebase
import FirebaseAuth

struct ProfileView: View {
    let user = Auth.auth().currentUser
    @State private var showingAlert = false
    
//    init() {
//        FirebaseManager.configure()
//    }
    
    var body: some View {
        VStack {
            if let user = user {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text(user.displayName ?? "No name")
                    .font(.title)
                
                Text(user.email ?? "No email")
                    .font(.subheadline)
                
                Spacer()
                
                Button(action: {
                    self.showingAlert = true
                }) {
                    Text("Sign Out")
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Are you sure you want to sign out?"),
                          primaryButton: .destructive(Text("Sign Out")) {
                        try! Auth.auth().signOut()
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                          },
                          secondaryButton: .cancel())
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
