import SwiftUI
import KeychainAccess

private enum KeychainKeys {
    static let accessToken = "access_token"
    static let refreshToken = "refresh_token"
    static let serviceKey = "com.mindgames.auth"
}

final class AuthService: ObservableObject {
    
    // MARK: - Static Properties
    
    static let shared = AuthService()
    
    @Published var isLoggedIn: Bool = false
    
    // MARK: - Private Properties
    
    private let client = HTTPClient.shared
    private let keychain = Keychain(service: KeychainKeys.serviceKey)
    private var isSendedRefresh: Bool = false
    
    // MARK: - Init
    
    private init() {
        isLoggedIn = isUserLoggedIn()
    }
    
    // MARK: - Public Methods
    
    func isUserLoggedIn() -> Bool {
        return getAccessToken() != nil
    }
    
    func getAccessToken() -> String? {
        return keychain[KeychainKeys.accessToken]
    }
    
    func getRefreshToken() -> String? {
        return keychain[KeychainKeys.refreshToken]
    }
    
    func saveAccessToken(_ token: String) async {
        keychain[KeychainKeys.accessToken] = token
        await MainActor.run {
            isLoggedIn = true
        }
    }
    
    func saveRefreshToken(_ token: String) async {
        keychain[KeychainKeys.refreshToken] = token
        await MainActor.run {
            isLoggedIn = true
        }
    }
    
    func logout() {
        isLoggedIn = false
        keychain[KeychainKeys.accessToken] = nil
        keychain[KeychainKeys.refreshToken] = nil
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
            let tokenResponse: TokenResponse = try await client.sendRequest(requestType: .register(body))
            await saveAccessToken(tokenResponse.accessToken)
            await saveRefreshToken(tokenResponse.refreshToken)
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
            let tokenResponse: TokenResponse = try await client.sendRequest(requestType: .login(body))
            await saveAccessToken(tokenResponse.accessToken)
            await saveRefreshToken(tokenResponse.refreshToken)
        } catch {
            throw error
        }
    }
    
    func refreshTokenIfNeeded() async -> Bool {
        guard !isSendedRefresh else { return false }
        
        guard let refresh = getRefreshToken() else {
            await MainActor.run {
                logout()
            }
            return false
        }
        
        isSendedRefresh = true
        
        do {
            let body = RefreshTokenRequest(refreshToken: refresh)
            let response: TokenResponse = try await client.sendRequest(requestType: .refresh(body))
            await saveAccessToken(response.accessToken)
            await saveRefreshToken(response.refreshToken)
            isSendedRefresh = false
            return true
        } catch {
            await MainActor.run {
                logout()
                isSendedRefresh = false
            }
            return false
        }
    }
}
