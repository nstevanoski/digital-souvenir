import SwiftUI
import Firebase

struct ProfileView: View {
    
    @EnvironmentObject var user: UserViewModel
    @EnvironmentObject var orderVM: OrderViewModel
    
    @State private var showingAlert = false

    let auth = Auth.auth()
    
    var body: some View {
        NavigationView{
            ZStack{
                Rectangle()
                    .foregroundColor(.white)
                    .padding(.top, 60)
                VStack {
                    Circle()
                        .frame(width: 140)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3)
                        .overlay(content: {
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 80, height: 80)
                        })
                        .padding(.top, 10)
                    
                    VStack{
                        if !user.userIsAnonymous{
                            Text(user.user?.username ?? "Hello!").bold().font(.system(size: 20))
                        }
                        ScrollView{
                            List{
                                Section(header: Text("General")){
                                    NavigationLink(destination: UserOrdersView(), label: {
                                        Text("Orders")
                                        
                                    })
                                }
                            }
                            .listStyle(.grouped)
                            .scrollDisabled(true)
                            .scrollContentBackground(.hidden)
                            .frame(height:100)
                            
                            List{
                                Section(header: Text("Application")){
                                    NavigationLink(destination: NotificationsView(), label: {
                                        Text("Notifications")
                                    })
                                    NavigationLink(destination: AboutAppView(), label: {
                                        Text("Application Information")
                                    })
                                }
                            }
                            .listStyle(.grouped)
                            .scrollDisabled(true)
                            .scrollContentBackground(.hidden)
                            .frame(height:150)
                            
                            if(!user.userIsAnonymous){
                                List{
                                    Section(header: Text("Account")){
                                        NavigationLink(destination: ChangePasswordView(), label: {
                                            Text("Change Password")
                                        })
                                    }
                                }
                                .listStyle(.grouped)
                                .scrollDisabled(true)
                                .scrollContentBackground(.hidden)
                                .frame(height:175)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Profile")
            .toolbar{
                ToolbarItem(placement: .principal){
                    Text("Profile").font(.headline).bold()
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        self.showingAlert = true
                    }) {
                        Text("Sign out")
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Are you sure you want to sign out?"),primaryButton: .destructive(
                            Text("Sign Out")) {
                                user.signOut()
                            },secondaryButton: .cancel())
                    }
                }
            }
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.1))
        .onAppear{
            orderVM.getUserOrders()
        }
    }
}



struct ProfileView_Previews: PreviewProvider {
    static let myEnvObject = UserViewModel()

    static var previews: some View {
        ProfileView()
            .environmentObject(myEnvObject)
    }
}

struct ChangePasswordView: View{
    
    @State var password = ""
    @State var newPassword = ""
    @State var newPassword2 = ""
    
    @State var isSecured: Bool = true
    @State var isSecured2: Bool = true
    @State var isSecured3: Bool = true
    
    @EnvironmentObject var user: UserViewModel
    
    let borderColor = Color(red: 107.0/255.0, green: 164.0/255.0, blue: 252.0/255.0)
    
    var body: some View{
        VStack{
            HStack{
                ZStack(alignment: .trailing){
                    Group{
                        if isSecured {
                            SecureField("Current password", text: $password).padding()
                                .autocapitalization(.none)
                                .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                                .padding(.top, 5)
                        } else {
                            TextField("Current password", text: $password).padding()
                                .autocapitalization(.none)
                                .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                                .padding(.top, 5)
                        }
                    }
                    Spacer()
                    Button {
                        isSecured.toggle()
                    } label: {
                        Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    }.padding()
                }
            }
            .padding(.horizontal, 25)

            HStack{
                ZStack(alignment: .trailing){
                    Group{
                        if isSecured2 {
                            SecureField("New Password", text: $newPassword).padding()
                                .autocapitalization(.none)
                                .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                                .padding(.top, 5)
                        } else {
                            TextField("New Password", text: $newPassword).padding()
                                .autocapitalization(.none)
                                .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                                .padding(.top, 5)
                        }
                    }
                    Spacer()
                    Button {
                        isSecured2.toggle()
                    } label: {
                        Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    }.padding()
                }
            }
            .padding(.horizontal, 25)
            
            HStack{
                ZStack(alignment: .trailing){
                    Group{
                        if isSecured3 {
                            SecureField("Confirm new password", text: $newPassword2).padding()
                                .autocapitalization(.none)
                                .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                                .padding(.top, 5)
                        } else {
                            TextField("Confirm new password", text: $newPassword2).padding()
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                                .padding(.top, 5)
                        }
                    }
                    Spacer()
                    Button {
                        isSecured3.toggle()
                    } label: {
                        Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    }.padding()
                }
            }
            .padding(.horizontal, 25)

            Button(action: {
                if !password.isEmpty && !newPassword.isEmpty && !newPassword2.isEmpty {
                    if newPassword == newPassword2{
                        user.changePassword(email: user.user!.userEmail, currentPassword: password, newPassword: newPassword){ error in
                            if error != nil {
                                user.updateAlert(title: "error", message: error?.localizedDescription ?? "Something went wrong")
                            } else {
                                user.updateAlert(title: "Success!", message: "Password has been changed")
                                
                            }
                        }
                        
                    } else {
                        user.updateAlert(title: "error", message: "The passwords are different.")
                    }
                } else {
                    user.updateAlert(title: "error", message: "All field are required")

                }
            }) {
                Text("Change Password")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                 .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("Dominant"))
            .cornerRadius(6)
            .padding(.top, 15)
            Spacer()
        }
        .navigationTitle("Password Change")
        .alert(isPresented: $user.showingAlert){
            Alert(
                title: Text(user.alertTitle),
                message: Text(user.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct UserOrdersView: View{
    
    @EnvironmentObject var orderVM: OrderViewModel
    
    var body: some View{
        if self.orderVM.orders != nil{
            VStack{
                Divider()
                ScrollView{
                    ForEach(0..<self.orderVM.orders!.count, id: \.self){ index in
                        NavigationLink(destination: DetailedOrderView(order: self.orderVM.orders![index])){
                            VStack(alignment: .leading){
                                HStack{
                                    Text("Order of the day:")
                                        .foregroundColor(.black)
                                        .opacity(0.75)
                                        .padding(.leading)
                                    
                                    Text(self.orderVM.orders![index].date, format: .dateTime.day().month().year())
                                        .foregroundColor(.black)
                                        .opacity(0.75)
                                }
                                VStack{
                                    
                                    Text("Order no: \(self.orderVM.orders![index].id)")
                                        .foregroundColor(.black)
                                        .padding([.leading, .trailing, .top])
                                    Text("Number of items ordered: \(self.orderVM.orders![index].productIDs.count)")
                                        .foregroundColor(.black)
                                        .padding([.leading, .trailing, .bottom])
                                    VStack(alignment: .trailing){
                                        HStack{
                                            Spacer()
                                            NavigationLink(destination: DetailedOrderView(order: self.orderVM.orders![index])){
                                                Text("Details of the order")
                                                    .foregroundColor(.orange)
                                                    .padding(.trailing)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Divider()
                    }
                    Spacer()
                }
            }
        }
        else{
            Text("There are no orders")
        }
    }
}
struct DetailedOrderView: View{
    
    @State var order: Order
    
    var body: some View{
        
        List{
            Section(header: Text("Order no \(order.id)")){
                HStack{
                    Text("Status")
                    Spacer()
                    if( order.status == "Completed"){
                        Text(order.status).foregroundColor(.green)
                    }
                    else {
                        Text(order.status)
                    }
                }
                HStack{
                    Text("Order value")
                    Spacer()
                    Text("\(order.totalPrice) EUR")
                }
            }
            
            Section(header: Text("Buyer")){
                HStack{
                    Text("First name")
                    Spacer()
                    Text(order.firstName)
                }
                HStack{
                    Text("Last name")
                    Spacer()
                    Text(order.lastName)
                }
            }
            
            Section(header: Text("Shipping")){
                HStack{
                    Text("City")
                    Spacer()
                    Text(order.city)
                }
                HStack{
                    Text("Street")
                    Spacer()
                    Text(order.street)
                }
                HStack{
                    Text("Street Number")
                    Spacer()
                    Text(order.streetNumber)
                }
                HStack{
                    Text("House number")
                    Spacer()
                    Text(order.houseNumber)
                }
            }
            
            Section(header: Text("Payment")){
                HStack{
                    Text("Cardholder name")
                    Spacer()
                    Text(order.cardHolderFirstname)
                }
                HStack{
                    Text("Cardholder name")
                    Spacer()
                    Text(order.cardHolderLastname)
                }
                HStack{
                    Text("Card number")
                    Spacer()
                    Text(order.cardNumber)
                }
            }
            Section(header: Text("Purchased product")){
                ForEach(0..<order.productIDs.count, id: \.self) { index in
                    ProductOrderLoader(productID: order.productIDs[index])
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct ProductOrderLoader: View{
    
    @State var productID: String
    @EnvironmentObject var productVM: ProductViewModel
    
    var body: some View{
        ScrollView{
            LazyVStack{
                if self.productVM.products != nil{
                    ForEach(self.productVM.products!.filter{$0.id.contains(self.productID)}, id: \.id){ product in
                        NavigationLink(destination: ProductDetailsView(product: product)) {
                            ProductOrderCell(product: product)}
                    }
                }
            }
        }
    }
}

struct ProductOrderCell: View{
    
    @State var product: Product
    @EnvironmentObject var productVM: ProductViewModel

    var body: some View{
        VStack(alignment: .leading){
            HStack{
//                ProductSearchCellImage(imageURL: product.imageURL).padding(.leading)
                Spacer()
                Text(product.name)
                Spacer()
            }
            .foregroundColor(.black)
        }
        .foregroundColor(.black)
    }
}

struct NotificationsView: View{
        
    @State var recommendtaionToggleIsActive: Bool = false
    @State var orderToggleIsActive: Bool = false
    
    var body: some View{
        VStack{
            Toggle(
                isOn: $recommendtaionToggleIsActive,
                label: {
                    Text("Recommended")
                })
            .toggleStyle(SwitchToggleStyle(tint: .green))
            .padding()
            .background(
                Color(.gray)
                    .opacity(0.25)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            )
            .padding()
            
            Toggle(
                isOn: $orderToggleIsActive,
                label: {
                    Text("Order notifications")
                })
            .toggleStyle(SwitchToggleStyle(tint: .green))
            .padding()
            .background(
                Color(.gray)
                    .opacity(0.25)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            )
            .padding()
        }
        Spacer()
    }
}

struct AboutAppView: View{
        
    @EnvironmentObject var user: UserViewModel
    
    var body: some View{
        VStack{
            GroupBoxRowView(name: "Developer", content: "Nikola Stevanoski")
            Divider()
            GroupBoxRowView(name: "Compatibility", content: "iOS 16+")
            Divider()
            GroupBoxRowView(name: "Version", content: "1.0")
            Divider()
        }
        Spacer()
    }
}

struct GroupBoxLabelView: View {
    
    var labelText: String
    var labelImage: String
    
    var body: some View {
        HStack {
            Text(labelText.uppercased()).fontWeight(.bold)
            Spacer()
            Image(systemName: labelImage)
        }
    }
}

struct GroupBoxRowView: View{
    var name: String
    var content: String
    var linkLabel: String? = nil
    
    var body: some View{
        HStack{
            Text(name)
                .foregroundColor(.gray)
                .padding()
            Spacer()
            if linkLabel != nil{
                Link(content, destination: URL(string: "https://\(linkLabel!)")!)
                    .padding()

            } else {
                Text(content)
                    .padding()
            }
        }
    }
}
