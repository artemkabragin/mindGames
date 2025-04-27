import SwiftUI

struct RegisterView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    
    let authService = AuthService.shared
    
    var body: some View {
        ZStack {
            Color.orange.opacity(0.7).ignoresSafeArea(.all)
            
            VStack {
                TextField("Username", text: $username)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Зарегистрироваться") {
                    Task {
                        await register()
                    }
                }
                .padding()
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
//                if isLoggedIn {
//                    Text("Logged in successfully!")
//                        .foregroundColor(.green)
//                }
            }
            .padding()
        }
    }
    
    func register() async {
        errorMessage = nil
        
        do {
            let authenticated = try await authService.register(
                username: username,
                password: password
            )
            DispatchQueue.main.async {
//                isLoggedIn = true
                print("Token: \(authenticated.value)")
            }
        } catch {
            if let errorResponse = error as? ErrorResponse {
                errorMessage = "\(errorResponse.reason)"
            }
        }
    }
}

#Preview {
    RegisterView()
}
