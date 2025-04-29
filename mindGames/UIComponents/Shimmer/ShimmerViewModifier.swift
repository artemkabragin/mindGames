import SwiftUI

struct ShimmerViewModifier: ViewModifier {
    private let configuration: ShimmerConfiguration = .default
    @State private var startPoint: UnitPoint
    @State private var endPoint: UnitPoint
    
    init() {
        _startPoint = .init(wrappedValue: configuration.initialLocation.start)
        _endPoint = .init(wrappedValue: configuration.initialLocation.end)
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            LinearGradient(
                gradient: configuration.gradient,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .opacity(configuration.opacity)
            .blendMode(.overlay)
            .clipShape(.rect(cornerRadius: 10))
            .onAppear {
                withAnimation(Animation.linear(duration: configuration.duration).repeatForever(autoreverses: false)) {
                    startPoint = configuration.finalLocation.start
                    endPoint = configuration.finalLocation.end
                }
            }
        }
    }
}
