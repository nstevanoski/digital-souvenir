import SwiftUI

struct CartView: View {
    
    @EnvironmentObject var productVM: ProductViewModel

    var body: some View {
        NavigationView {
            if self.productVM.userCartProductIDs.count > 0 {
                VStack{
                    Divider()
                    ScrollView {
                        if productVM.products != nil {
                            ForEach(productVM.products!.filter { product in
                                productVM.userCartProductIDs.contains(product.id)
                            }, id: \.id) { product in
                                NavigationLink(destination: ProductDetailsView(product: product)) {
                                    ProductCartCell(product: product)
                                }
                                
                                Divider()
                                    .overlay(Color.blue)
                            }
                        } else {
                            LoadingView()
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Cart")
                    Spacer()
                    VStack{
                        Divider()
                        HStack{
                            Text("Total Value:")
                                .padding([.leading])
                            
                            Spacer()
                            Text("\(self.productVM.userCartTotalPrice) EUR")
                                .padding([.trailing])
                        }
                        NavigationLink(destination: PurchaseView(productIDs: self.productVM.userCartProductIDs)){
                            HStack{
                                Image(systemName: "eye").bold().font(.body).foregroundColor(.white)
                                Text("Make a purchase").bold().font(.body).foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color("Dominant"))
                            .cornerRadius(6)
                        }
                        .padding([.leading, .trailing, .bottom])
                    }
                }
            }
            else{
                Text("Your cart is empty")
                Spacer()
            }
        }
        .onAppear{
            productVM.getUserCart()
        }
    }
}


struct ProductCartCell: View{
    
    @State var product: Product
    @EnvironmentObject var productVM: ProductViewModel

    var body: some View{
        VStack(alignment: .leading){
            
            HStack{
                ProductSearchCellImage(imageURL: product.imageURL).padding(.leading)
                VStack{
                    HStack{
                        Text(product.name)
                            .lineLimit(2)
                            .font(.callout)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                        Spacer()
                        Button {
                            productVM.removeProductFromCart(productID: product.id)
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title)
                                .padding([.leading, .trailing])
                                .clipShape(Circle())
                        }
                    }
                     HStack{
                        if product.isOnSale{
                            VStack{
                                Text("\(product.price) EUR")
                                    .bold()
                                    .padding([.leading, .trailing])
                                    .font(.callout)
                                    .strikethrough()
                                    .foregroundColor(.red).opacity(0.75)
                                    .frame(alignment: .trailing)
                                
                                Text("\(product.onSalePrice) EUR")
                                    .padding([.leading,.trailing])
                                    .foregroundColor(.black)
                                    .font(.callout)
                                    .fontWeight(.bold)
                            }
                            .frame(alignment: .center)
                        }
                        else {
                            Text("\(product.price) EUR")
                                .bold()
                                .font(.callout)
                                .foregroundColor(.black)
                                .padding()
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}
