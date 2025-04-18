import SwiftUI

struct Card: Identifiable, Hashable {
    
    let id = UUID()
    let color: Color
    var isMatched: Bool
    var isSelected: Bool
    
    init(
        color: Color,
        isMatched: Bool = false,
        isSelected: Bool = false
    ) {
        self.color = color
        self.isMatched = isMatched
        self.isSelected = isSelected
    }
}

// MARK: - Helpers

extension Card {
    var isFlipped: Bool {
        isMatched || isSelected
    }
}

//extension Card {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//    static func ==(_ lhs: Card, _ rhs: Card) -> Bool {
//        return lhs.color == rhs.color
//    }
//}

extension Array where Element == Card {
    func hasSameColor(by count: Int = 2) -> Bool {
        let selectedCard = filter { $0.isSelected }.suffix(count)
        let firstColor = selectedCard.first?.color ?? .clear
        let result = selectedCard.allSatisfy { card in
            card.color == firstColor
        }
        return result
    }
}

//extension Card {
//    func toggle(with isFlipped: Bool) -> Self {
//        Card(
//            color: color,
//            isFlipped: isFlipped
//        )
//    }
//    
//    func toggle() -> Self {
//        Card(
//            color: color,
//            isFlipped: !isFlipped
//        )
//    }
//}
