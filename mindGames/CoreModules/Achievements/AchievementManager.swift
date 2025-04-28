import Foundation

enum AchievementAction {
    case gamePlayed
    case newRecord(Double)
    case perfectGame
}

struct AchievementResponse: Decodable {
    var achievements: [AchievementWithProgress]
}

struct AchievementWithProgress: Decodable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let type: AchievementType
    let gameType: GameType
    let isUnlocked: Bool
    let progress: Double
    let dateUnlocked: Date?
}


final class AchievementManager: ObservableObject {
    
    // MARK: - Static Properties
    
    static let shared = AchievementManager()
    
    // MARK: - Public Properties
    
    @Published private(set) var achievements: [AchievementWithProgress] = []
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults.standard
    private let achievementsKey = "game_achievements"
    private let lastPlayedKey = "last_played_date"
    private let bannerService = BannerService.shared
    
    // MARK: - Init
    
//    private init() {
//        Task {
//            await loadAchievements()
//        }
//    }
    
    // MARK: - Public Methods
    
//    func updateAchievement(
//        for gameType: GameType,
//        action: AchievementAction
//    ) {
//        let gameAchievements = achievements.filter { $0.gameType == gameType }
//        
//        for achievement in gameAchievements {
//            var updatedAchievement = achievement
//            
//            switch (achievement.type, action) {
//            case (.dailyStreak, .gamePlayed):
//                if let lastPlayed = userDefaults.object(forKey: lastPlayedKey) as? Date {
//                    let calendar = Calendar.current
//                    if calendar.isDateInToday(lastPlayed) {
//                        updatedAchievement.progress += 1.0
//                    } else if calendar.isDate(lastPlayed, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: Date())!) {
//                        updatedAchievement.progress += 1.0
//                    } else {
//                        updatedAchievement.progress = 1.0
//                    }
//                } else {
//                    updatedAchievement.progress = 1.0
//                }
//                
//            case (.highScore, .newRecord(let score)):
//                switch gameType {
//                case .reaction:
//                    if score < 0.5 {
//                        updatedAchievement.isUnlocked = true
//                        updatedAchievement.dateUnlocked = Date()
//                    }
//                default:
//                    break
//                }
//                
//            case (.totalPlays, .gamePlayed):
//                updatedAchievement.progress += 1.0
//                
//            case (.perfectScore, .perfectGame):
//                updatedAchievement.isUnlocked = true
//                updatedAchievement.dateUnlocked = Date()
//                
//            default:
//                break
//            }
//            
//            setBannerIfNeeded(
//                achievement: achievement,
//                updatedAchievement: updatedAchievement
//            )
//            
//            if let globalIndex = achievements.firstIndex(where: { $0.id == achievement.id }) {
//                achievements[globalIndex] = updatedAchievement
//            }
//        }
//        
//        userDefaults.set(Date(), forKey: lastPlayedKey)
//        saveAchievements()
//    }
    
    func getAchievements() async -> [AchievementWithProgress] {
        return (try? await AchievementService.shared.loadAchievements()
            .sorted { $0.progress > $1.progress }
            .sorted { $0.isUnlocked && !$1.isUnlocked }
        ) ?? []
    }
}

// MARK: - Private Methods

private extension AchievementManager {
    func setBannerIfNeeded(
        achievement: Achievement,
        updatedAchievement: Achievement
    ) {
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
