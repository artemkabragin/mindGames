import SwiftUI

struct ShimmerConfiguration {
    let gradient: Gradient
    let initialLocation: (start: UnitPoint, end: UnitPoint)
    let finalLocation: (start: UnitPoint, end: UnitPoint)
    let duration: TimeInterval
    let opacity: Double
    
    static let `default` = ShimmerConfiguration(
        gradient: Gradient(stops: [
            .init(color: .black, location: 0),
            .init(color: .white, location: 0.5),
            .init(color: .black, location: 1)
        ]),
        initialLocation: (start: UnitPoint(x: -1, y: 0.5), end: .leading),
        finalLocation: (start: .trailing, end: UnitPoint(x: 2, y: 0.5)),
        duration: 1.5,
        opacity: 0.6
    )
}
