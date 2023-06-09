import SwiftUI

struct ProductCardList: View {
    
    let products: [Product]
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State private var product: Product? = nil
    
    @EnvironmentObject var userVM: UserViewModel

    var body: some View {
        LazyVGrid(columns: columns){
            ForEach(products){product in
                VStack {
                    NavigationLink(destination: ProductDetailsView(product: product).environmentObject(userVM)){
                        ProductCard(product: product)
                    }
                }
            }
        }
    }
}

struct ProductCardList_Previews: PreviewProvider {
    static var previews: some View {
        ProductCardList(products: Product.sampleProducts)
            .environmentObject(ProductViewModel())
    }
}
