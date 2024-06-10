import SwiftUI

struct LoginView: View {
    @StateObject private var viewmodel = LoginViewViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color.green
                        .ignoresSafeArea()
                    Circle()
                        .scale(1.7)
                        .foregroundStyle(.white.opacity(0.15))
                    Circle()
                        .scale(1.35)
                        .foregroundStyle(.white)
                    
                    VStack {
                        Text("Login")
                            .font(.system(size: 50))
                            .bold()
                            .padding()
                        
                        if !viewmodel.errorMessage.isEmpty {
                            Text(viewmodel.errorMessage)
                                .foregroundStyle(Color.red)
                        }
                        
                        TextField("Email Address", text: $viewmodel.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)

                        
                        SecureField("Password", text: $viewmodel.password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                        
                        Button("Login") {
                            viewmodel.login()
                        }
                        .foregroundStyle(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                    }
                    
                    VStack {
                        Spacer()
                        Text("New around here?")
                        
                        NavigationLink("Create an account", destination: RegisterView())
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
