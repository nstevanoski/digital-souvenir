import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var orderVM: OrderViewModel
    @EnvironmentObject var productVM: ProductViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if let orders = self.orderVM.orders {
                    let allProducts = orders.flatMap { $0.productIDs }
                    Text("\(NSArray(array: allProducts))")
                    
                    ForEach(0..<self.orderVM.orders!.count, id: \.self){ index in
                        SouvenirList(order: self.orderVM.orders![index]).environmentObject(productVM)
                    }
                }
            }.onAppear {
                orderVM.getUserOrders();
            }
            .navigationBarTitle("My Souvenirs")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SouvenirList: View {
    @State var order: Order
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @EnvironmentObject var productVM: ProductViewModel

    var body: some View {
        LazyVGrid(columns: columns){
            ForEach(0..<order.productIDs.count, id: \.self) { index in
                VStack {
                    SouvenirCard(productID: order.productIDs[index]).environmentObject(productVM)
                }
            }
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

struct SouvenirCell: View{
    @State var product: Product
    @EnvironmentObject var productVM: ProductViewModel

    var body: some View{
        VStack(alignment: .leading, spacing: 10) {
            ProductCardImage(imageURL: product.imageURL)
                .scaledToFit()
                .frame(height: 170)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .padding(.horizontal, 10)
            }
            
            Spacer()
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
