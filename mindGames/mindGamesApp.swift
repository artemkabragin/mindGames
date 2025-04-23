import SwiftUI

@main
struct mindGamesApp: App {
    @StateObject var bannerService = BannerService.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(bannerService)
        }
    }
}
