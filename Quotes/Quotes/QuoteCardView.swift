import SwiftUI

struct QuoteCardView: View {
    var quote: QuoteEntity
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
            
            VStack(alignment: .leading) {
                Text(quote.q ?? "")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                
                Text(quote.a ?? "")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
