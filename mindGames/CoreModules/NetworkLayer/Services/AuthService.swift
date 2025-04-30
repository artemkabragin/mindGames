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
    
    // MARK: - Public Properties
    
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
        AppState.shared.showOnboarding = true
        AppState.shared.isOnboardingComplete = false
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
            let authResponse: AuthResponse = try await client.sendRequest(requestType: .register(body))
            await proccessAuthResponse(authResponse)
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
            let authResponse: AuthResponse = try await client.sendRequest(requestType: .login(body))
            await proccessAuthResponse(authResponse)
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
            let authResponse: AuthResponse = try await client.sendRequest(requestType: .refresh(body))
            await proccessAuthResponse(authResponse)
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
    
    // MARK: - Private Methods
    
    private func proccessAuthResponse(_ authResponse: AuthResponse) async {
        let tokenResponse = authResponse.token
        
        await saveAccessToken(tokenResponse.accessToken)
        await saveRefreshToken(tokenResponse.refreshToken)
        
        let isOnboardingComplete = authResponse.user.isOnboardingComplete
        let userName = authResponse.user.username
        
        await MainActor.run {
            AppState.shared.userName = userName
            AppState.shared.isOnboardingComplete = isOnboardingComplete
            AppState.shared.showOnboarding = !isOnboardingComplete
        }
    }
}
