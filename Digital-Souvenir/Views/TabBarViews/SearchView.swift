import SwiftUI

enum Categories: String, CaseIterable {
    case afghanistan = "Afghanistan"
    case albania = "Albania"
    case algeria = "Algeria"
    case andorra = "Andorra"
    case angola = "Angola"
    case antiguaAndBarbuda = "Antigua and Barbuda"
    case argentina = "Argentina"
    case armenia = "Armenia"
    case australia = "Australia"
    case austria = "Austria"
    case azerbaijan = "Azerbaijan"
    case bahamas = "Bahamas"
    case bahrain = "Bahrain"
    case bangladesh = "Bangladesh"
    case barbados = "Barbados"
    case belarus = "Belarus"
    case belgium = "Belgium"
    case belize = "Belize"
    case benin = "Benin"
    case bhutan = "Bhutan"
    case bolivia = "Bolivia"
    case bosniaAndHerzegovina = "Bosnia and Herzegovina"
}

struct SearchView: View {
    
    @State var searchText = ""
    @EnvironmentObject var productVM: ProductViewModel

    var body: some View {
        NavigationView{
            VStack{
                if self.productVM.products != nil {
                    if !self.searchText.isEmpty {
                        ScrollView{
                            LazyVStack{
                                ForEach(self.productVM.products!.filter { $0.name.localizedCaseInsensitiveContains(searchText) }, id: \.id) { product in
                                    NavigationLink(destination: ProductDetailsView(product: product)) {
                                        SearchCell(product: product)
                                    }
                                    Divider().overlay(Color.blue)
                                }
                            }
                        }
                    } else {
                        List {
                            Section(header: Text("Categories")) {
                                ForEach(Categories.allCases, id: \.rawValue) { item in
                                    NavigationLink(destination: SearchByCategory(category: item.rawValue), label: {
                                        Text(item.rawValue)
                                    })
                                }
                            }
                        }
                        .listStyle(.grouped)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Products").font(.headline).bold()
                }
            }
        }

        .background(.gray.opacity(0.1))
        .searchable(text: $searchText)
        .autocorrectionDisabled(true)
        .autocapitalization(.none)
    }

}

struct SearchByCategory: View{
    
    var category: String
    @EnvironmentObject var productVM: ProductViewModel
    @State var productCounter: Int = 0

    var body: some View{
        NavigationView{
            if productCounter > 0 {
                ScrollView{
                    LazyVStack{
                        VStack{
                            Text("Found \(productCounter) products")
                            Divider()
                                .overlay(Color.blue)
                            if(self.productVM.products != nil){
                                ForEach(self.productVM.products!.filter{$0.category.contains(self.category) }, id: \.id) { product in
                                    SearchCell(product: product)
                                    Divider()
                                        .overlay(Color.blue)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            } else {
                Text("There are currently no products in this category")
                Spacer()
            }
            
        }
        .onAppear{
            self.productCounter = self.productVM.products!.filter{$0.category.contains(self.category) }.count
        }

        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(category)
        
    }

}

struct SearchCell: View{
    
    var product: Product
    @EnvironmentObject var productVM: ProductViewModel
    
    var body: some View{
        HStack{
            ProductSearchCellImage(imageURL: product.imageURL).padding(.leading)
            VStack{
                Text(product.name)
                    .lineLimit(2)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding([.top, .leading, .trailing])
                    .foregroundColor(.black)
                HStack{
                    Button {
                        productVM.addProductToCart(productID: product.id)
                    } label: {
                        HStack() {
                               Image(systemName: "cart.badge.plus")
                                .bold().font(.callout)
                               Text("Add to cart")
                                .bold().font(.footnote)
                           }

                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(6)
                           
                    }
                    Spacer()
                    if product.isOnSale{
                        VStack{
                            Text("\(product.price)")
                                .bold()
                               .padding([.top, .leading, .trailing])
                                .font(.callout)
                                .strikethrough()
                                .foregroundColor(.black).opacity(0.75)
                                .frame(alignment: .trailing)

                            Text("\(product.onSalePrice) EUR")
                                .padding([.leading,.trailing])
                                .foregroundColor(.black)
                        }
                        .frame(alignment: .center)
                    }
                    else {
                        Text("\(product.price) EUR")
                            .bold()
                            .foregroundColor(.black)
                            .padding()
                    }
                    
                }

            }

        }
        
    }
    
}

struct ProductSearchCellImage: View {
    @StateObject private var imageLoader = ImageLoader()
    let imageURL: URL
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.white)
                .frame(width: 80, height: 112, alignment: .center)
                .cornerRadius(12)
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
                                    .cornerRadius(12)
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                )
        }
        .cornerRadius(12)
        .onAppear {
            imageLoader.loadImage(with: imageURL)
        }
        
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCell(product: Product.sampleProduct)
            .environmentObject(ProductViewModel())
    }
}
