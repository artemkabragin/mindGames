import SwiftUI

@main
struct mindGamesApp: App {
    
    @StateObject var bannerService = BannerService()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainScreenView()
                if let type = bannerService.bannerType {
                    BannerView(banner: type)
                }
            }
            .environmentObject(bannerService)
        }
    }
}
