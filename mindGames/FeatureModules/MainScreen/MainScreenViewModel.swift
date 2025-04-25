import SwiftUI

final class MainScreenViewModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var achivements: [Achievement] = []
    
    private let achievementManager: AchievementManager
    
    init(
        achievementManager: AchievementManager = .shared
    ) {
        self.achievementManager = achievementManager
    }
    
    @MainActor
    func getAchievements() async {
        achivements = await achievementManager.getAchievements()
    }
}
