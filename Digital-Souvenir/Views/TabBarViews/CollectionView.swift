import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var orderVM: OrderViewModel
    @EnvironmentObject var productVM: ProductViewModel
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        NavigationView {
            VStack {
                if let orders = self.orderVM.orders {
                    let allProducts = orders.flatMap { $0.productIDs }
                    
                    ScrollView {
                        LazyVGrid(columns: columns){
                            ForEach(0..<allProducts.count, id: \.self) { index in
                                VStack {
                                    SouvenirCard(productID: allProducts[index]).environmentObject(productVM)
                                }
                            }
                        }
                    }
                }
            }.onAppear {
                orderVM.getUserOrders();
            }
            .navigationBarTitle("My Souvenirs")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 10)
        }
    }
}

struct SouvenirCard: View{
    @State var productID: String
    @EnvironmentObject var productVM: ProductViewModel
    
    var body: some View{
        if self.productVM.products != nil{
            ForEach(self.productVM.products!.filter{$0.id.contains(self.productID)}, id: \.id){ product in
                SouvenirCell(product: product)}
        }
    }
}

struct SouvenirCell: View {
    @State var product: Product
    @EnvironmentObject var productVM: ProductViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Product Image
            AsyncImage(url: product.imageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 170)
                    .cornerRadius(10) // Add corner radius to the image
            } placeholder: {
                ProgressView()
            }
            
            // Product Name
            Text(product.name)
                .font(.title3)
                .foregroundColor(.primary)
                .lineLimit(2)
                .padding(.horizontal, 10)
            
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.yellow, Color.orange]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}



struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
