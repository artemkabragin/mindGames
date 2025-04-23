import Foundation

struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let type: AchievementType
    let gameType: GameType
    var isUnlocked: Bool
    var progress: Double // 0.0 to 1.0
    var dateUnlocked: Date?
    
    init(
        id: String,
        type: AchievementType,
        gameType: GameType,
        isUnlocked: Bool = false,
        progress: Double = 0.0,
        dateUnlocked: Date? = nil
    ) {
        self.id = id
        self.title = type.getTitle(by: gameType)
        self.description = type.getDescription(by: gameType)
        self.type = type
        self.gameType = gameType
        self.isUnlocked = isUnlocked
        self.progress = progress
        self.dateUnlocked = dateUnlocked
    }
}

// MARK: - Helpers

extension Achievement {
    static func defaultAchievements(for gameType: GameType) -> [Achievement] {
        switch gameType {
        case .cardFlip:
            return [
                Achievement(
                    id: "card_flip_streak_7",
                    type: .dailyStreak,
                    gameType: .cardFlip,
                    isUnlocked: false,
                    progress: 0.0
                ),
                Achievement(
                    id: "card_flip_perfect",
                    type: .perfectScore,
                    gameType: .cardFlip,
                    isUnlocked: false,
                    progress: 0.0
                ),
                Achievement(
                    id: "card_flip_plays_50",
                    type: .totalPlays,
                    gameType: .cardFlip,
                    isUnlocked: false,
                    progress: 0.0
                )
            ]
        case .reaction:
            return [
                Achievement(
                    id: "reaction_streak_10",
                    type: .dailyStreak,
                    gameType: .reaction,
                    isUnlocked: false,
                    progress: 0.0
                ),
                Achievement(
                    id: "reaction_record_0.2",
                    type: .highScore,
                    gameType: .reaction,
                    isUnlocked: false,
                    progress: 0.0
                ),
                Achievement(
                    id: "reaction_plays_100",
                    type: .totalPlays,
                    gameType: .reaction,
                    isUnlocked: false,
                    progress: 0.0
                )
            ]
        case .colorMatch:
            return [
                Achievement(
                    id: "color_match_streak_5",
                    type: .dailyStreak,
                    gameType: .colorMatch,
                    isUnlocked: false,
                    progress: 0.0
                ),
                Achievement(
                    id: "color_match_perfect",
                    type: .perfectScore,
                    gameType: .colorMatch,
                    isUnlocked: false,
                    progress: 0.0
                ),
                Achievement(
                    id: "color_match_plays_75",
                    type: .totalPlays,
                    gameType: .colorMatch,
                    isUnlocked: false,
                    progress: 0.0
                )
            ]
        }
    }
}
