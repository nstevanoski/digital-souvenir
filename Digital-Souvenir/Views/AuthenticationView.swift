import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var user: UserViewModel

    var body: some View {
        SignInView().environmentObject(user)
        .alert(isPresented: $user.showingAlert){
            Alert(
                title: Text(user.alertTitle),
                message: Text(user.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    @State var passwordConfirmation = ""
    @State var username = ""
    
    @State var alert = false
    @State var visible = false
    @State var color = Color.black.opacity(0.7)
    
    @EnvironmentObject var user: UserViewModel

    @State var isSecured: Bool = true
    @State var isSecuredConfirmation: Bool = true
    
    @State var error = ""
    @State var title = ""
    
    let borderColor = Color(red: 107.0/255.0, green: 164.0/255.0, blue: 252.0/255.0)
    
    var body: some View{
        VStack() {
            Text("Sign in")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 5)
                        
            TextField("Email", text: self.$email)
                .autocapitalization(.none)
                .padding()
                .background(RoundedRectangle(cornerRadius: 6).stroke(borderColor, lineWidth: 2))
                .padding(.top, 5)
            
            HStack(spacing: 15){
                VStack {
                    if self.visible {
                        TextField("Password", text: self.$password)
                            .autocapitalization(.none)
                    } else {
                        SecureField("Password", text: self.$password)
                            .autocapitalization(.none)
                    }
                }
                
                Button(action: {
                    self.visible.toggle()
                }) {
                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(self.color)
                        .opacity(0.8)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 6)
            .stroke(borderColor, lineWidth: 2))
            .padding(.top, 10)
            
            HStack{
                Spacer()
                NavigationLink(destination: ResetPasswordView().environmentObject(user)){
                    Text("Forgot password?")
                        .foregroundColor(Color("Dominant"))
                }
            }
            
            // Sign in button
            Button(action: {
                if (!email.isEmpty && !password.isEmpty) {
                    user.signIn(email: email, password: password)
                } else {
                    user.alertTitle = "Error"
                    user.alertMessage = "All fields are required!"
                    user.showingAlert = true
                }
            }) {
                Text("Sign in")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color("Dominant"))
                    .cornerRadius(6)
            }
            .padding(.top, 15)
            .alert(isPresented: $alert) { () -> Alert in
                return Alert(title: Text("\(self.title)"), message: Text("\(self.error)"), dismissButton:
                    .default(Text("OK").fontWeight(.semibold)))
            }
            
            Spacer();
            
            // Anonimous sign in
            Button(action: {
                user.signInAnonymously()
            }) {
                Text("Sign in Anonymously")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(6)
            }
            .padding(.top, 15)
            
            // Facebook sign-in button
            Button(action: {
                // Handle Facebook sign-in action
                user.signInWithFacebook()
            }) {
                Text("Sign in with Facebook")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(6)
            }
            .padding(.top, 15)
            
            // Gmail sign-in button
            Button(action: {
                // Handle Gmail sign-in action
                user.signInWithGoogle(from: getRootViewController())
            }) {
                Text("Sign in with Gmail")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(6)
            }
            .padding(.top, 10)
            
            HStack(spacing: 5){
                Text("Don't have an account?")
                
                NavigationLink(destination: SignUpView().environmentObject(user)){
                    Text("Sign up")
                    .fontWeight(.bold)
                    .foregroundColor(Color("Dominant"))
                }
            }.padding(.top, 25)
        }
        .padding(.horizontal, 25)
        
    }
}

struct SignUpView: View {
    
    @State var email = ""
    @State var password = ""
    @State var passwordConfirmation = ""
    @State var username = ""
    
    @EnvironmentObject var user: UserViewModel

    @State var isSecured: Bool = true
    @State var isSecuredConfirmation: Bool = true
    
    let borderColor = Color(red: 107.0/255.0, green: 164.0/255.0, blue: 252.0/255.0)

    var body: some View {
        VStack {
            VStack{
                VStack{
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                        .padding(.top, 5)
                    
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                        .padding(.top, 5)
                    
                    ZStack(alignment: .trailing){
                        Group{
                            if isSecured {
                                SecureField("Password", text: $password)
                                    .autocapitalization(.none)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                                    .padding(.top, 5)
                            } else {
                                TextField("Password", text: $password)
                                    .autocapitalization(.none)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                                    .padding(.top, 5)
                            }
                        }
                        Button {
                            isSecured.toggle()
                        } label: {
                            Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                .accentColor(.gray)
                        }
                        .padding()
                    }
                    
                    ZStack(alignment: .trailing){
                        Group{
                            if isSecuredConfirmation {
                                SecureField("Password Confirmation", text: $passwordConfirmation)
                                    .autocapitalization(.none)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                                    .padding(.top, 5)
                            } else {
                                TextField("Password Confirmation", text: $passwordConfirmation)
                                    .autocapitalization(.none)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                                    .padding(.top, 5)
                            }
                        }
                        Button {
                            isSecuredConfirmation.toggle()
                        } label: {
                            Image(systemName: self.isSecuredConfirmation ? "eye.slash" : "eye")
                                .accentColor(.gray)
                        }.padding()
                    }
                    
                    Button(action: {
                        if username.isEmpty || email.isEmpty || password.isEmpty || passwordConfirmation.isEmpty {
                            user.updateAlert(title: "Error", message: "All fields are required")
                            return
                        }

                        if password != passwordConfirmation {
                            user.updateAlert(title: "Error", message: "The passwords must be the same")
                            return
                        }

                        user.signUp(email: email, password: password, username: username)
                    }) {
                        Text("Sign up")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                         .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(Color("Dominant"))
                    .cornerRadius(6)
                    .padding(.top, 15)
                }
                Spacer()
            }
            .navigationTitle("Sign up")
            .padding(.top, 15)
            .padding(.horizontal, 25)
        }
    }
}

struct ResetPasswordView: View {
    
    @State var email = ""
    @EnvironmentObject var user: UserViewModel
    
    let borderColor = Color(red: 107.0/255.0, green: 164.0/255.0, blue: 252.0/255.0)
    
    var body: some View {
        VStack {
            VStack{
                VStack {
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                        .padding(.top, 5)
                
                    Button(action: {
                        if !email.isEmpty {
                            user.resetPassword(email: email)
                        } else {
                            user.updateAlert(title: "Error", message: "Email field is required")
                        }
                        
                    }) {
                        Text("Submit")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                         .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(Color("Dominant"))
                    .cornerRadius(6)
                    .padding(.top, 15)
                }
                Spacer()
            }
            .navigationTitle("Reset password")
        }
        .padding(.top, 15)
        .padding(.horizontal, 25)
    }
}
