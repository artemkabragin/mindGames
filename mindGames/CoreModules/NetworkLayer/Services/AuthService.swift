import KeychainAccess

private enum KeychainKeys {
    static let authToken = "auth_token"
    static let serviceKey = "com.mindgames.auth"
}

final class AuthService {
    
    // MARK: - Static Properties
    
    static let shared = AuthService()
    
    // MARK: - Private Properties
    
    private let client = HTTPClient.shared
    private let keychain = Keychain(service: KeychainKeys.serviceKey)
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Public Methods
    
    // Проверка, залогинен ли пользователь
    func isUserLoggedIn() -> Bool {
        if let _ = keychain[KeychainKeys.authToken] {
            return true
        }
        return false
    }
    
    // Получение токена из Keychain
    func getAuthToken() -> String? {
        return keychain[KeychainKeys.authToken]
    }
    
    // Сохранение токена в Keychain
    func saveAuthToken(_ token: String) {
        keychain[KeychainKeys.authToken] = token
    }
    
    // Удаление токена (для выхода)
    func logout() {
        keychain[KeychainKeys.authToken] = nil
    }
    
    func register(
        username: String,
        password: String
    ) async throws -> Token {
        let body = UserRegisterRequest(
            username: username,
            password: password
        )
        do {
            return try await client.sendRequest(requestType: .register(body))
        } catch {
            throw error
        }
    }
    
    // Функция для логина
    func login(
        username: String,
        password: String
    ) async throws -> Token {
        let body = UserCredentials(
            username: username,
            password: password
        )        
        do {
            return try await client.sendRequest(requestType: .login(body))
        } catch {
            throw error
        }
    }
}


public struct ErrorResponse: Decodable, Equatable, Error {
    public var reason: String
}
