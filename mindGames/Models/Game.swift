import Foundation

enum GameType {
    case cardFlip
    case reaction
    case colorMatch
}

struct Game: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
    let type: GameType
    
    static let games: [Game] = [
        Game(
            name: "Card Flip",
            description: "Match pairs of cards with the same color",
            imageName: "cards.fill",
            type: .cardFlip
        ),
        Game(
            name: "Reaction Time",
            description: "Tap the green circle as fast as you can",
            imageName: "circle.fill",
            type: .reaction
        ),
        Game(
            name: "Color Match",
            description: "Match the color name with its actual color",
            imageName: "paintpalette.fill",
            type: .colorMatch
        )
    ]
} 
