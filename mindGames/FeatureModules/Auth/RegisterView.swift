import SwiftUI

private enum Constants {
    static let loginTextFieldTitle = "Логин"
    static let passwordTextFieldTitle = "Пароль"
    static let registerButtonTitle = "Зарегистрироваться"
}

struct RegisterView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = false
    
    let authService = AuthService.shared
    
    var body: some View {
        ZStack {
            Color.orange.opacity(0.2).ignoresSafeArea(.all)
            
            VStack {
                TextField(Constants.loginTextFieldTitle, text: $username)
                    .padding(.horizontal)
                    .textFieldStyle(.roundedBorder)
                    
                SecureField(Constants.passwordTextFieldTitle, text: $password)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                
                registerButton
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                if isLoggedIn {
                    Text("Logged in successfully!")
                        .foregroundColor(.green)
                }
            }
            .padding()
        }
    }
    
    func register() async {
        errorMessage = nil
        
        do {
            let _ = try await authService.register(
                username: username,
                password: password
            )
        } catch {
            if let errorResponse = error as? ErrorResponse {
                errorMessage = "\(errorResponse.reason)"
            }
        }
    }
}

// MARK: - Login button

private extension RegisterView {
    var registerButton: some View {
        Button(action: {
            Task {
                await register()
            }
        }) {
            HStack {
                Spacer()
                Text(Constants.registerButtonTitle)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding()
            .background(Color.orange)
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    RegisterView()
}
