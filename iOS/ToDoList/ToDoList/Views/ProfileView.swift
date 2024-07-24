import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if let user = viewModel.user {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Name: ")
                                .bold()
                                .padding()
                            Text(user.name)
                        }
                        HStack {
                            Text("Email: ")
                                .bold()
                                .padding()
                            Text(user.email)
                        }
                        HStack {
                            Text("Member since: ")
                                .bold()
                                .padding()
                            Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                        }
                    }
                } else {
                    Text("Loading profile...")
                }
                
                Button("Log out") {
                    viewModel.logOut()
                }
                .foregroundStyle(.white)
                .frame(width: 300, height: 50)
                .background(Color.red)
                .cornerRadius(10)
                .padding()
                
                Spacer()
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
}

#Preview {
    ProfileView()
}
