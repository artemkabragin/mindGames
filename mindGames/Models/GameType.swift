enum GameType: String, CaseIterable, Codable {
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
    
    var description: String {
        switch self {
        case .cardFlip:
            "Match pairs of cards with the same color"
        case .reaction:
            "Tap the green circle as fast as you can"
        case .colorMatch:
            "Match the color name with its actual color"
        }
    }
    
    var imageName: String {
        switch self {
        case .cardFlip:
            "rectangle.on.rectangle.square.fill"
        case .reaction:
            "circle.fill"
        case .colorMatch:
            "paintpalette.fill"
        }
    }
}
