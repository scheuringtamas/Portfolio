import SwiftUI

struct NoItemsView: View {
    var body: some View {
        VStack {
            Image(systemName: "pencil.and.list.clipboard")
                .font(.system(size: 60))
            
            Text("There are no expenses")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
        }
    }
}

#Preview {
    NoItemsView()
}
