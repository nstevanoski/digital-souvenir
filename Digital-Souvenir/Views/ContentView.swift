import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    let productVM = ProductViewModel();
    let userVM = UserViewModel();
    let orderVM = OrderViewModel();
    
    var body: some View {
        VStack{
            if self.status{
                TabView {
                    HomeView().tabItem {
                        Image(systemName: "house.fill")}.tag(0).environmentObject(productVM).environmentObject(userVM)
                    CartView().tabItem {
                        Image(systemName: "cart.fill")}.tag(2).environmentObject(productVM)
                    SearchView().tabItem {
                        Image(systemName: "magnifyingglass")}.tag(1).environmentObject(productVM)
                    ProfileView().tabItem {
                        Image(systemName: "person.fill")}.tag(3).environmentObject(userVM).environmentObject(orderVM).environmentObject(productVM)
                }.accentColor(.black)
            } else {
                VStack{
                    AuthenticationView().environmentObject(userVM)
                }
            }
        }.onAppear{
            NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

