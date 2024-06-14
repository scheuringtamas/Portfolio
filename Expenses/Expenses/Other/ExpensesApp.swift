import SwiftUI
import SwiftData

@main
struct ExpensesApp: App {
    @Query(sort: [SortDescriptor(\Expense.date, order: .reverse), SortDescriptor(\Expense.name)]) var expenses: [Expense]

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Expenses", systemImage: "list.bullet.clipboard")
                    }
                
                ExpenseChartView()
                    .tabItem {
                        Label("Statistics", systemImage: "chart.bar.xaxis")
                    }
            }
        }
        .modelContainer(for: Expense.self)
    }
}
