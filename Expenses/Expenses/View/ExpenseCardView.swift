import SwiftUI

struct ExpenseCardView: View {
    let expense: Expense
        
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.name)
                    .font(.system(size: 20))

                Text(expense.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 15))
                    .padding(.top, 3)
            }

            Spacer()
            Text(String(expense.value) + "$")
                .font(.system(size: 20))
                .padding()
        }
    }
}
