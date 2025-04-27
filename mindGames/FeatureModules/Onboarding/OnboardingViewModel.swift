import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    @ViewBuilder func destination(for screen: OnboardingScreen) -> some View {
        switch screen {
        case .hello:
            OnboardingHelloScreenView()
        case .cardFlip:
            CardFlipGameView(onboardingViewModel: self)
        case .reaction:
            ReactionGameView(onboardingViewModel: self)
        case .colorMatch:
            ColorMatchGameView(onboardingViewModel: self)
        case .finish:
            OnboardingFinishScreenView()
        }
    }
}
