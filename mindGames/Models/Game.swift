import Foundation

struct Game: Identifiable, Hashable {
    let id = UUID()
    let type: GameType
    
    static let games: [Game] = GameType.allCases.map { Game(type: $0) }
} 
