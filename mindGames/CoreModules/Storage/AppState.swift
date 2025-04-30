import SwiftUI

final class AppState: ObservableObject {
    
    // MARK: - Static Properties
    
    static let shared = AppState()
    
    // MARK: - Public Properties
    
    @AppStorage(StorageKeys.userName.rawValue) var userName: String = ""
    @AppStorage(StorageKeys.isOnboardingComplete.rawValue) var isOnboardingComplete: Bool = false
    @AppStorage(StorageKeys.showOnboarding.rawValue) var showOnboarding: Bool = true
    
    @AppStorage(StorageKeys.hasSeenCardFlipTutorial.rawValue) var hasSeenCardFlipTutorial: Bool = false
    @AppStorage(StorageKeys.hasSeenReactionTutorial.rawValue) var hasSeenReactionTutorial: Bool = false
    @AppStorage(StorageKeys.hasSeenColorMatchTutorial.rawValue) var hasSeenColorMatchTutorial: Bool = false
    
    // MARK: - Init
    
    private init() {
        showOnboarding = !isOnboardingComplete
//        showOnboarding = false
//        hasSeenCardFlipTutorial = false
//        hasSeenReactionTutorial = false
//        hasSeenColorMatchTutorial = false
    }
}
