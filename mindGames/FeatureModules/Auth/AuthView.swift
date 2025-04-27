import SwiftUI

struct AuthView: View {
    
    @StateObject var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            VStack(spacing: 20) {
                Button("Login") {
                    viewModel.navigationPath.append(AuthDestination.login)
                }
                .padding()
                
                Button("Register") {
                    viewModel.navigationPath.append(AuthDestination.register)
                }
                .padding()
            }
            .navigationTitle("Добро пожаловать!")
            .navigationDestination(for: AuthDestination.self) { screen in
                viewModel.destination(for: screen)
            }
        }
        
    }
}

#Preview {
    AuthView()
}
