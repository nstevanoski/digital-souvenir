import SwiftUI

struct CartView: View {
    
    @EnvironmentObject var productVM: ProductViewModel
    @EnvironmentObject var userVM: UserViewModel

    var body: some View {
        NavigationView {
            if self.productVM.userCartProductIDs.count > 0 {
                VStack {
                    Divider()
                    ScrollView {
                        if let products = productVM.products {
                            ForEach(products.filter { product in
                                productVM.userCartProductIDs.contains(product.id)
                            }, id: \.id) { product in
                                NavigationLink(destination: ProductDetailsView(product: product).environmentObject(userVM)) {
                                    ProductCartCell(product: product)
                                }
                                .padding(.vertical, 8)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .cornerRadius(8)
                                .padding(.horizontal)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            }
                        } else {
                            LoadingView()
                        }
                    }
                    .navigationBarTitle("Cart")
                    
                    Spacer()
                    
                    VStack {
                        Divider()
                        HStack {
                            Text("Total Value:")
                                .font(.headline)
                                .padding(.leading)
                            
                            Spacer()
                            
                            Text("\(self.productVM.userCartTotalPrice) EUR")
                                .font(.headline)
                                .padding(.trailing)
                        }
                        .padding(.vertical)
                        
                        NavigationLink(destination: PurchaseView(productIDs: self.productVM.userCartProductIDs)) {
                            HStack {
                                Image(systemName: "creditcard")
                                    .font(.body)
                                    .foregroundColor(.white)
                                
                                Text("Make a Purchase")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(6)
                        }
                        .padding([.horizontal, .bottom])
                    }
                }
            } else {
                Text("Your cart is empty")
                Spacer()
            }
        }
        .onAppear {
            productVM.getUserCart()
        }
    }
}

struct ProductCartCell: View {
    
    @State var product: Product
    @EnvironmentObject var productVM: ProductViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ProductSearchCellImage(imageURL: product.imageURL)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                
                VStack(alignment: .leading) {
                    Text(product.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(2)
                    
                    HStack {
                        if product.isOnSale {
                            Text("\(product.price) EUR")
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .strikethrough()
                            
                            Text("\(product.onSalePrice) EUR")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        } else {
                            Text("\(product.price) EUR")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    productVM.removeProductFromCart(productID: product.id)
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .padding(.trailing)
            }
        }
        .padding(.vertical, 8)
    }
}

