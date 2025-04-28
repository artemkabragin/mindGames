import Foundation

final class AchievementManager: ObservableObject {
    
    // MARK: - Static Properties
    
    static let shared = AchievementManager()
    
    // MARK: - Public Properties
    
    @Published private(set) var achievements: [AchievementWithProgress] = []
    
    // MARK: - Private Properties
    
    private let bannerService = BannerService.shared
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Public Methods
    
    func getAchievements() async -> [AchievementWithProgress] {
        let achievements = (try? await AchievementService.shared.loadAchievements()
            .sorted { $0.progress > $1.progress }
            .sorted { $0.isUnlocked && !$1.isUnlocked }
        ) ?? []
        self.achievements = achievements
        return achievements
    }
    
    func processNewAchievements(_ achievements: [AchievementWithProgress]) {
        achievements.forEach { achievement in
            setBannerIfNeeded(updatedAchievement: achievement)
        }
    }
}

// MARK: - Private Methods

private extension AchievementManager {
    func setBannerIfNeeded(updatedAchievement: AchievementWithProgress) {
        guard let achievement = achievements.first(where: { $0.id == updatedAchievement.id }) else { return }
        let achievementIsUnlocked = achievement.isUnlocked
        let updatedAchievementIsUnlocked = updatedAchievement.isUnlocked
        let needShowBanner = !achievementIsUnlocked && updatedAchievementIsUnlocked
        
        guard needShowBanner else { return }
        
        let bannerMessage = String.getNewAchievementBannerMessage(by: updatedAchievement.title)
        bannerService.setBanner(.success(message: bannerMessage))
    }
}

// MARK: - String

private extension String {
    static func getNewAchievementBannerMessage(by achievementName: String) -> String {
        return "Новое достижение! \(achievementName)"
    }
}
