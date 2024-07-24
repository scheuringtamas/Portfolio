import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: BookEntity.entity(), sortDescriptors: []) var harryPotterBooks: FetchedResults<BookEntity>
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(harryPotterBooks, id: \.self) { book in
                            CardView(bookentity: book)
                                .padding()
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 20)
            }
            .coordinateSpace(name: "ScrollView")
            .padding(.top, 15)
            .onAppear {
                if harryPotterBooks.isEmpty {
                    DataManager(context: viewContext).getBooks()
                }
            }
        }
    }
}
