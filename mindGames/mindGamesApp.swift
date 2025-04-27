import SwiftUI

@main
struct MindGamesApp: App {
    @StateObject var appState = AppState()
    @StateObject var bannerService = BannerService.shared
    
    var body: some Scene {
        WindowGroup {

            if appState.showOnboarding {
                OnboardingHelloScreenView()
                    .environmentObject(appState)
            } else {
                RootView()
                    .environmentObject(bannerService)
            }
        }
    }
}
