import SwiftUI

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerViewModifier())
    }
}
