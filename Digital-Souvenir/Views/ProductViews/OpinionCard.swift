import SwiftUI

struct OpinionCard: View {
    
    var rate: Int
    var review: String
    var username: String
    var maxRate: Int = 5
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                HStack(alignment: .center){
                    Text(username)
                        .padding()
                        .font(.body)
                        .foregroundColor(.black).opacity(0.5)
                    Spacer()
                    RateStars(rating: rate, max: 5)
                        .font(.body)
                }
                Spacer()
                Text(review).padding([.leading, .trailing, .bottom])
                Spacer()
            }
            .frame(height: 120)
        }
        .background(Color(red: 255/255, green: 255/255, blue: 255/255))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
        .padding([.leading, .trailing])
        
    }
    struct RateStars: View {
        
        var rating: Int?
        var max: Int = 5
        
        var body: some View {
            HStack(spacing: 2) {
                ForEach(1..<(max+1), id: \.self) { index in
                    Image(systemName: self.starType(index: index))
                        .font(.title3)
                        .foregroundColor(Color.blue)
                }
            }
            .padding([.bottom, .trailing, .leading])
        }
        
        func starType(index: Int) -> String {
            if let rating = self.rating {
                return index <= rating ? "star.fill" : "star"
            }
            else {
                return "star"
            }
        }
    }
}


struct OpinionCard_Previews: PreviewProvider {
    static var previews: some View {
        OpinionCard(rate: 5, review: "Fajny telefon ", username: "Tester1")
    }
}
