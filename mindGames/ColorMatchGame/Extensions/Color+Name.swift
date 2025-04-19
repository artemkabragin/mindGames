import SwiftUI

extension Color {
    func getName() -> String {
        switch self {
        case .red:
            return "Красный"
        case .blue:
            return "Синий"
        case .green:
            return "Зелёный"
        case .yellow:
            return "Жёлтый"
        case .purple:
            return "Фиолетовый"
        case .orange:
            return "Оранжевый"
        default:
            return "\(self)"
        }
    }
}
