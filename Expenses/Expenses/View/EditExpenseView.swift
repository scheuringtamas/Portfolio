import SwiftUI
import SwiftData

struct EditExpenseView: View {
    @Bindable var expense: Expense
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $expense.name)
                }
                
                Section("Value") {
                    TextField("Value", value: $expense.value, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                }
                
                Section("Date") {
                    DatePicker("Due Date", selection: $expense.date, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
            }
            .navigationTitle("Edit an expense")
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Expense.self, configurations: config)
        let example = Expense(name: "Example expense name", date: .now, value: 10.5)
        
        return EditExpenseView(expense: example).modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
