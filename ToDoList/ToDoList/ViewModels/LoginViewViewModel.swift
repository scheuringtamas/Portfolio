import Foundation
import FirebaseAuth

class LoginViewViewModel: ObservableObject {
    @Published var emailAddress = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func login() {
        guard validate() else {
            return
        }
        
        Auth.auth().signIn(withEmail: emailAddress, password: password)
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        
        guard !emailAddress.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty 
        else {
            errorMessage = "Please fill in all fields!"
            return false
        }
        
        guard emailAddress.contains("@") && emailAddress.contains(".") 
        else {
            errorMessage = "Please enter valid email"
            return false
        }
        return true
    }
}
