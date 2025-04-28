import SwiftUI
import KeychainAccess

private enum KeychainKeys {
    static let authToken = "auth_token"
    static let serviceKey = "com.mindgames.auth"
}

final class AuthService: ObservableObject {
    
    // MARK: - Static Properties
    
    static let shared = AuthService()
    
    @Published var isLoggedIn: Bool = false
    
    // MARK: - Private Properties
    
    private let client = HTTPClient.shared
    private let keychain = Keychain(service: KeychainKeys.serviceKey)
    
    // MARK: - Init
    
    private init() {
        isLoggedIn = isUserLoggedIn()
    }
    
    // MARK: - Public Methods
    
    func isUserLoggedIn() -> Bool {
        return getAuthToken() != nil
    }
    
    func getAuthToken() -> String? {
        return keychain[KeychainKeys.authToken]
    }
    
    func saveAuthToken(_ token: String) async {
        keychain[KeychainKeys.authToken] = token
        await MainActor.run {
            isLoggedIn = true
        }
    }
    
    func logout() {
        isLoggedIn = false
        keychain[KeychainKeys.authToken] = nil
    }
    
    func register(
        username: String,
        password: String
    ) async throws {
        let body = UserRegisterRequest(
            username: username,
            password: password
        )
        do {
            let authToken: AuthToken = try await client.sendRequest(requestType: .register(body))
            await saveAuthToken(authToken.value)
        } catch {
            throw error
        }
    }
    
    // Функция для логина
    func login(
        username: String,
        password: String
    ) async throws {
        let body = UserCredentials(
            username: username,
            password: password
        )
        do {
            let authToken: AuthToken = try await client.sendRequest(requestType: .login(body))
            await saveAuthToken(authToken.value)
        } catch {
            throw error
        }
    }
}
