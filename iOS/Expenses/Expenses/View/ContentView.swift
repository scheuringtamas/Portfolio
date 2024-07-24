import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Expense.date, order: .reverse), SortDescriptor(\Expense.name)]) var expenses: [Expense]
    @State private var searchText = ""
    
    var filteredExpenses: [Expense] {
        if searchText.isEmpty {
            return expenses
        } else {
            return expenses.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(filteredExpenses) { expense in
                        NavigationLink(destination: EditExpenseView(expense: expense)) {
                            VStack(spacing: 25) {
                                ExpenseCardView(expense: expense)
                            }
                        }
                    }
                    .onDelete(perform: deleteExpense)
                }
                .navigationTitle("Expenses")
                .toolbar {
                    NavigationLink(destination: ExpenseAddView(), label: {
                        Image(systemName: "plus")
                    })
                }
                .searchable(text: $searchText)
                .overlay {
                    if expenses.isEmpty {
                        NoItemsView()
                    }
                }
            }
        }
    }
    
    func deleteExpense(_ indexSet: IndexSet) {
        for index in indexSet {
            let expense = expenses[index]
            modelContext.delete(expense)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Expense.self, inMemory: true)
}
