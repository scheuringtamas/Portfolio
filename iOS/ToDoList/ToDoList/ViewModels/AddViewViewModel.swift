import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AddViewViewModel: ObservableObject {
    @Published var title = ""
    @Published var dueDate = Date()
    @Published var alertTitle = ""
    @Published var showAlert = false
    @Published var saveSuccess = false
    
    init() {
        
    }
    
    func save() {
        guard textIsAppropriate() else {
            showAlert = true
            alertTitle = "Invalid title"
            return
        }
        
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let newId = UUID().uuidString
        let newItem = Item(id: newId, title: title, dueDate: dueDate.timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false)
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("todos")
            .document(newId)
            .setData(newItem.asDictionary()) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added with ID: \(newId)")
                    self.saveSuccess = true
                }
            }
    }
    
    
    func textIsAppropriate() -> Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }
        
        return true
    }
    
    func getAlert() -> Alert {
        Alert(title: Text(alertTitle))
    }
}
