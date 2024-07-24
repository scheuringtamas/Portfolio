import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: QuoteEntity.entity(), sortDescriptors: []) var zenQuotes: FetchedResults<QuoteEntity>
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(zenQuotes, id: \.self) { quote in
                        QuoteCardView(quote: quote)
                    }
                }
            }      
            .onAppear {
                QuoteDataManager(context: viewContext).getQuotes()
            }
        }
    }
}
