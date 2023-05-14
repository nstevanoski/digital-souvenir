import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var productVM: ProductViewModel
    @EnvironmentObject var userVM: UserViewModel

    var body: some View {
        NavigationView{
            VStack{
                ScrollView(.vertical){
                    VStack(alignment: .leading){
                        if(productVM.promotedProducts != nil){
                            ProductCarousel(products: productVM.promotedProducts ?? (productVM.products)!)
                        }
                    }
                    VStack(alignment: .leading){
                        Text("More")
                            .font(.system(size:28))
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                        if(productVM.onSaleProducts != nil){
                            ProductCardList(products: productVM.onSaleProducts!).environmentObject(userVM)
                        }
                    }
                    Spacer(minLength: 40)
                }
            }
            .navigationBarTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }

        .onAppear{
            productVM.getPromotedProducts()
            productVM.getOnSaleProducts()
            productVM.getProducts()
            productVM.getUserWatchList()
            productVM.getUserCart()
        }
        
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
