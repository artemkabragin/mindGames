import SwiftUI

private enum Constants {
    static let title = "Добро пожаловать!"
    static let loginButtonTitle = "Войти"
    static let registerButtonTitle = "Зарегистрироваться"
}

struct AuthView: View {
    
    @StateObject var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            VStack(spacing: 12) {
                Text("Игры разума - развивайте свои память и внимание!")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.bottom, 30)
                loginButton
                registerButton
            }
            .navigationTitle(Constants.title)
            .navigationDestination(for: AuthDestination.self) { screen in
                viewModel.destination(for: screen)
            }
        }
    }
}

// MARK: - Login button

private extension AuthView {
    var loginButton: some View {
        Button(action: {
            viewModel.navigationPath.append(AuthDestination.login)
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
    }
}

// MARK: - Register button

private extension AuthView {
    var registerButton: some View {
        Button(action: {
            viewModel.navigationPath.append(AuthDestination.register)
        }) {
            HStack {
                Spacer()
                Text(Constants.registerButtonTitle)
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                    .stroke(.blue, lineWidth: 2)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    AuthView()
}
