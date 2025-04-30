import SwiftUI

private enum Constants {
    static let loginTextFieldTitle = "Логин"
    static let passwordTextFieldTitle = "Пароль"
    static let loginButtonTitle = "Войти"
}

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = false
    
    let authService = AuthService.shared
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.2).ignoresSafeArea(.all)
            
            VStack {
                TextField(Constants.loginTextFieldTitle, text: $username)
                    .padding(.horizontal)
                    .textFieldStyle(.roundedBorder)
                    
                SecureField(Constants.passwordTextFieldTitle, text: $password)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                
                loginButton
                
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
    
    func login() async {
        do {
            let _ = try await authService.login(
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

private extension LoginView {
    var loginButton: some View {
        Button(action: {
            Task {
                await login()
            }
        }) {
            HStack {
                Spacer()
                Text(Constants.loginButtonTitle)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    LoginView()
}
