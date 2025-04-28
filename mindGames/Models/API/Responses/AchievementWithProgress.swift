import Foundation

struct AchievementWithProgress: Decodable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let type: AchievementType
    let gameType: GameType
    let isUnlocked: Bool
    let progress: Double
    let dateUnlocked: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, type, gameType, isUnlocked, progress, dateUnlocked
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        type = try container.decode(AchievementType.self, forKey: .type)
        gameType = try container.decode(GameType.self, forKey: .gameType)
        isUnlocked = try container.decode(Bool.self, forKey: .isUnlocked)
        progress = try container.decode(Double.self, forKey: .progress)
        
        // Обработка даты с помощью ISO8601DateFormatter
        if let dateString = try container.decodeIfPresent(String.self, forKey: .dateUnlocked) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate, .withTime, .withTimeZone, .withDashSeparatorInDate, .withColonSeparatorInTime]
            
            if let decodedDate = formatter.date(from: dateString) {
                dateUnlocked = decodedDate
            } else {
                dateUnlocked = nil
            }
        } else {
            dateUnlocked = nil
        }
    }
}
