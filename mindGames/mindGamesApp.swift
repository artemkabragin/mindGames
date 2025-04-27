import SwiftUI

@main
struct MindGamesApp: App {
    
    @ObservedObject var appState = AppState.shared
    @ObservedObject var bannerService = BannerService.shared
    
    var body: some Scene {
        WindowGroup {
            if appState.showOnboarding {
                OnboardingHelloScreenView()
            } else {
                RootView()
                    .environmentObject(bannerService)
            }
        }
    }
}
