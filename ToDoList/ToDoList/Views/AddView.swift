import SwiftUI

struct AddView: View {
    @StateObject var viewModel = AddViewViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Title", text: $viewModel.title)
                    
                    DatePicker("Due Date", selection: $viewModel.dueDate)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    
                    Button("Save") {
                        viewModel.save()
                    }
                        .foregroundStyle(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
        .navigationTitle("Add an Item")
        .alert(isPresented: $viewModel.showAlert) {
            viewModel.getAlert()
        }
        .onChange(of: viewModel.saveSuccess) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    AddView()
}
