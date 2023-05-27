import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var productVM: ProductViewModel
    @EnvironmentObject var userVM: UserViewModel

    var body: some View {
        NavigationView {
            ZStack {

                VStack {
                    // Hero Image
                    Image("hero_image")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                        .overlay(Text("Digital Souvenirs Shop")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(),
                                 alignment: .bottom)
                        .padding(.bottom)
                    
                    // Products
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                            Text("Souvenirs")
                                .font(.system(size:28))
                                .multilineTextAlignment(.leading)
                                .padding(.leading)
                            if(productVM.onSaleProducts != nil){
                                ProductCardList(products: productVM.products!)
                                    .environmentObject(userVM)
                            }
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                
                // Alerts
                .alert(isPresented: $userVM.showingAlert){
                    Alert(
                        title: Text(userVM.alertTitle),
                        message: Text(userVM.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .alert(isPresented: $productVM.showingAlert){
                    Alert(
                        title: Text(productVM.alertTitle),
                        message: Text(productVM.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                // User profile button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Handle user profile action
                        }) {
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear{
                productVM.getPromotedProducts()
                productVM.getOnSaleProducts()
                productVM.getProducts()
                productVM.getUserWatchList()
                productVM.getUserCart()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
