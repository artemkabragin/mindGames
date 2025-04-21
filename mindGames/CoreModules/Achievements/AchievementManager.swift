import Foundation

enum AchievementAction {
    case gamePlayed
    case newRecord(Double)
    case perfectGame
}

class AchievementManager: ObservableObject {
    
    @Published private(set) var achievements: [Achievement] = []
    private let userDefaults = UserDefaults.standard
    private let achievementsKey = "game_achievements"
    private let lastPlayedKey = "last_played_date"
    
    static let shared = AchievementManager()
    
    private init() {
        loadAchievements()
    }
    
    private func loadAchievements() {
        if let data = userDefaults.data(forKey: achievementsKey),
           let decodedAchievements = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decodedAchievements
        } else {
            achievements = GameType.allCases.flatMap { gameType in
                Achievement.defaultAchievements(for: gameType)
            }
            saveAchievements()
        }
    }
    
    private func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            userDefaults.set(encoded, forKey: achievementsKey)
        }
    }
    
    func updateAchievement(
        for gameType: GameType,
        action: AchievementAction
    ) {
        let gameAchievements = achievements.filter { $0.gameType == gameType }
        
        for (index, achievement) in gameAchievements.enumerated() {
            var updatedAchievement = achievement
            
            switch (achievement.type, action) {
            case (.dailyStreak, .gamePlayed):
                if let lastPlayed = userDefaults.object(forKey: lastPlayedKey) as? Date {
                    let calendar = Calendar.current
                    if calendar.isDateInToday(lastPlayed) {
                        updatedAchievement.progress += 1.0
                    } else if calendar.isDate(lastPlayed, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: Date())!) {
                        updatedAchievement.progress += 1.0
                    } else {
                        updatedAchievement.progress = 1.0
                    }
                } else {
                    updatedAchievement.progress = 1.0
                }
                
            case (.highScore, .newRecord(let score)):
                switch gameType {
                case .reaction:
                    if score < 0.5 {
                        updatedAchievement.isUnlocked = true
                        updatedAchievement.dateUnlocked = Date()
                    }
                default:
                    break
                }
                
            case (.totalPlays, .gamePlayed):
                updatedAchievement.progress += 1.0
                
            case (.perfectScore, .perfectGame):
                updatedAchievement.isUnlocked = true
                updatedAchievement.dateUnlocked = Date()
                
            default:
                break
            }
            
            if let globalIndex = achievements.firstIndex(where: { $0.id == achievement.id }) {
                achievements[globalIndex] = updatedAchievement
            }
        }
        
        userDefaults.set(Date(), forKey: lastPlayedKey)
        saveAchievements()
    }
    
    func getAchievements() async -> [Achievement] {
        return achievements
            .sorted { $0.progress > $1.progress }
            .sorted { $0.isUnlocked && !$1.isUnlocked }
    }
} 
