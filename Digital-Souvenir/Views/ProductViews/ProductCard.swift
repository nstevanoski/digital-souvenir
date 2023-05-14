import SwiftUI

struct ProductCard: View {
    
    private let screenSize = UIScreen.main.bounds

    var product: Product

    var body: some View {
        ZStack{
            VStack {
                ProductCardImage(imageURL: product.imageURL).padding([.top, .bottom])
                VStack(alignment: .center){
                    Text(product.name)
                        .font(.subheadline)
                        .lineLimit(3)

                    Text("\(product.price)€")
                        .bold()
                        .padding(2)
                    
                }
                .foregroundColor(.black).opacity(1)
                Spacer()
            }
            .background(Color(red: 230/255, green: 230/255, blue: 230/255))

        }
        .frame()
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 1, y: 2)
        .padding([.leading, .trailing])
    }
}

struct ProductCardImage: View {
    @StateObject private var imageLoader = ImageLoader()
    let imageURL: URL
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.white)
                .frame(width: 150, height: 160, alignment: .center)
                .cornerRadius(6)
                .overlay(
                    ZStack {
                        ProgressView()
                        if imageLoader.image != nil {
                            HStack {
                                Spacer()
                                Image(uiImage: imageLoader.image!)
                                    .resizable()
                                    .compositingGroup()
                                    .clipped(antialiased: true)
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                )
        }
        .cornerRadius(6)
        .onAppear {
            imageLoader.loadImage(with: imageURL)
        }
    }
}

struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        ProductCard(product: Product(id: "1", name: "macbook pro 13 16/512", img: "https://www.tradeinn.com/f/13745/137457920/apple-macbook-pro-touch-bar-16-i9-2.3-16gb-1tb-ssd-laptop.jpg", price: 5500, amount: 3, description: "test", category: "laptopy", isOnSale: false, onSalePrice: 0, details: [], images: []))
    }
}
