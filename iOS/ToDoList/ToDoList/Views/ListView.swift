import SwiftUI
import FirebaseFirestoreSwift

struct ListView: View {
    @StateObject var viewModel: ListViewViewModel
    @FirestoreQuery var items: [Item]
    
    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos")
        self._viewModel = StateObject(wrappedValue: ListViewViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if(items.isEmpty) {
                    NoItemsView()
                        .transition(AnyTransition.opacity.animation(.easeIn))
                } else {
                    List(items) { item in
                        ListRowView(item: item)
                            .swipeActions {
                                Button("Delete") {
                                    viewModel.delete(id: item.id)
                                }
                                .tint(.red)
                            }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("To Do List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ListView(userId: "jdbhDtnl7cRGOdsMVQcCEksnfiU2")
}
