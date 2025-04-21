enum GameType: CaseIterable, Codable {
    case cardFlip
    case reaction
    case colorMatch
    
    var name: String {
        switch self {
        case .cardFlip:
            "Переворот карт"
        case .reaction:
            "Круг реакции"
        case .colorMatch:
            "Цветные слова"
        }
    }
}
