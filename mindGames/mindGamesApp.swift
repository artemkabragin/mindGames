import SwiftUI

@main
struct MindGamesApp: App {
    
    @ObservedObject var appState = AppState.shared
    @ObservedObject var bannerService = BannerService.shared
    @ObservedObject var authService = AuthService.shared
    
    var body: some Scene {
        WindowGroup {
            if authService.isLoggedIn {
                if appState.showOnboarding {
                    OnboardingHelloScreenView()
                } else {
                    RootView()
                        .environmentObject(bannerService)
                }
            } else {
                AuthView()
            }
        }
    }
}
