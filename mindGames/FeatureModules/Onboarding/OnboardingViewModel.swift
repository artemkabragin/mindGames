import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    @ViewBuilder func destination(for screen: OnboardingScreen) -> some View {
        switch screen {
        case .hello:
            OnboardingHelloScreenView()
        case .cardFlipTutorial:
            CardFlipGameView()
        }
    }
}
