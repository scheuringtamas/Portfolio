import SwiftUI
import SwiftData

struct ExpenseAddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var alertTitle = ""
    @State private var showAlert = false
    @State private var saveSuccess = false
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var value: Double = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Name") {
                        TextField("Name", text: $name)
                    }
                    
                    Section("Value") {
                        TextField("Value", value: $value, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                    }
                    
                    Section("Date") {
                        DatePicker("Due Date", selection: $date, in: ...Date(), displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                        
                        Button("Save") {
                                save()
                        }
                        .foregroundStyle(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                    }
                }
                .navigationTitle("Add an item")
                .toolbar {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                .alert(isPresented: $showAlert) {
                    getAlert()
                }
            }
        }
    }
    
    func save() {
        guard InPutIsAppropriate() else {
            showAlert = true
            alertTitle = "Invalid title or expense value"
            return
        }
        
        let newExpense = Expense(name: name, date: date, value: value)
        modelContext.insert(newExpense)
        
        do {
            try modelContext.save()
            self.saveSuccess = true
            dismiss()
        } catch  {
            print("Failed to save expense: \(error)")
        }
    }
    
    
    func InPutIsAppropriate() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty && value > 0 else {
            return false
        }
        
        return true
    }
    
    func getAlert() -> Alert {
        Alert(title: Text(alertTitle))
    }
}

#Preview {
    ExpenseAddView()
}
