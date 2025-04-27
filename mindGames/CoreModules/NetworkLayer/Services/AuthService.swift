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
        logout()
        isLoggedIn = isUserLoggedIn()
    }
    
    // MARK: - Public Methods
    
    // Проверка, залогинен ли пользователь
    func isUserLoggedIn() -> Bool {
        return getAuthToken() != nil
    }
    
    // Получение токена из Keychain
    func getAuthToken() -> String? {
        return keychain[KeychainKeys.authToken]
    }
    
    // Сохранение токена в Keychain
    func saveAuthToken(_ token: String) {
        isLoggedIn = true
        keychain[KeychainKeys.authToken] = token
    }
    
    // Удаление токена (для выхода)
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
            saveAuthToken(authToken.value)
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
            saveAuthToken(authToken.value)
        } catch {
            throw error
        }
    }
}
