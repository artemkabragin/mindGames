import SwiftUI

enum AuthDestination {
    case auth
    case login
    case register
}

final class AuthViewModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    @ViewBuilder func destination(for screen: AuthDestination) -> some View {
        switch screen {
        case .auth:
            AuthView()
        case .login:
            LoginView()
        case .register:
            RegisterView()
        }
    }
}
