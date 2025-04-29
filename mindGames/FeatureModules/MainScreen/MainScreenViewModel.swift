import SwiftUI

final class MainScreenViewModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var achivements: [AchievementWithProgress] = []
    @Published var isLoadingAchievements = true
    
    private let achievementManager: AchievementManager
    
    init(
        achievementManager: AchievementManager = .shared
    ) {
        self.achievementManager = achievementManager
    }
    
    @MainActor
    func getAchievements() async {
        isLoadingAchievements = true
        try? await Task.sleep(for: .seconds(3))
        achivements = await achievementManager.getAchievements()
        isLoadingAchievements = false
    }
}
