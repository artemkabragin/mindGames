import SwiftUI

@main
struct mindGamesApp: App {
    @StateObject var viewModel = AppViewModel()
    
    
    @StateObject var bannerService = BannerService.shared
    
    var body: some Scene {
        WindowGroup {

            if viewModel.showOnboarding {
                OnboardingHelloScreenView()
            } else {
                RootView()
                    .environmentObject(bannerService)
                
            }
        }
    }
}

enum StorageKeys: String {
    case isFirstLaunch
}

final class AppViewModel: ObservableObject {
    
    @Published var showOnboarding = false
    
    let storageManager = UserDefaultsManager.shared
    
    init() {
        checkFirstLaunch()
    }
}

// MARK: - Private Methods

extension AppViewModel {
    private func checkFirstLaunch() {
        showOnboarding = true
//        let isFirstLaunch = storageManager.load(Bool.self, forKey: .isFirstLaunch) ?? true
//        
//        showOnboarding = isFirstLaunch
//        
//        storageManager.save(false, forKey: .isFirstLaunch)
    }
}
