import SwiftUI
import SwiftData
import Charts

struct ExpenseChartView: View {
    @Query(sort: [SortDescriptor(\Expense.date, order: .reverse), SortDescriptor(\Expense.name)]) var expenses: [Expense]
    @State private var selectedMonth = DateFormatter().monthSymbols[Calendar.current.component(.month, from: Date()) - 1]
    
    var monthlyExpenses: [String: Double] {
        var expensesByMonth = [String: Double]()
        
        for expense in expenses {
            let month = DateFormatter().monthSymbols[Calendar.current.component(.month, from: expense.date) - 1]
            expensesByMonth[month, default: 0] += expense.value
        }
        
        return expensesByMonth
    }
    
    var body: some View {
        NavigationStack {
            Chart {
                ForEach(DateFormatter().monthSymbols, id: \.self) { month in
                    if let total = monthlyExpenses[month] {
                        BarMark(
                            x: .value("Month", month),
                            y: .value("Total Expenses", total)
                        )
                        .foregroundStyle(by: .value("Month", month))
                    }
                }
            }
            .frame(height: 300)
            .padding()
            .navigationTitle("Monthly Expenses")
            
            List {
                Section("Total Expenses") {
                    Picker("Select Month", selection: $selectedMonth) {
                        ForEach(DateFormatter().monthSymbols, id: \.self) { month in
                            Text(month).tag(month)
                        }
                    }
                    Text("Total: \(totalExpenses(for: selectedMonth), specifier: "%.2f")$")
                        .bold()
                }
            }
        }
    }
    
    func totalExpenses(for monthName: String) -> Double {
        guard let monthIndex = DateFormatter().monthSymbols.firstIndex(of: monthName) else {
            return 0.0
        }
        
        let monthNumber = monthIndex + 1
        
        return expenses
            .filter { Calendar.current.component(.month, from: $0.date) == monthNumber }
            .reduce(0) { $0 + $1.value }
    }
}
