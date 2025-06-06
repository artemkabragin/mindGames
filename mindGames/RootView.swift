import SwiftUI

enum MainScreenDestination: Hashable {
    case person
    case game(GameType)
}

struct RootView: View {
    @EnvironmentObject var bannerService: BannerService
    @StateObject var viewModel = MainScreenViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            
            NavigationStack(path: $viewModel.navigationPath) {
                MainScreenView(viewModel: viewModel)
                    .navigationDestination(for: MainScreenDestination.self) { screen in
                        destination(for: screen)
                    }
            }
            
            if let type = bannerService.bannerType {
                BannerView(banner: type)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: bannerService.bannerType)
    }
    
    @ViewBuilder func destination(for screen: MainScreenDestination) -> some View {
        switch screen {
            
        case .person:
            UserProfileView()
            
        case .game(let gameType):
            switch gameType {
            case .cardFlip:
                CardFlipGameView(onboardingViewModel: OnboardingViewModel())
            case .reaction:
                ReactionGameView(onboardingViewModel: OnboardingViewModel())
            case .colorMatch:
                ColorMatchGameView(onboardingViewModel: OnboardingViewModel())
            }
        }
    }
}
