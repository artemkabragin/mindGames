import SwiftUI

struct RootView: View {
    @EnvironmentObject var bannerService: BannerService
    @StateObject var viewModel = MainScreenViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            NavigationStack(path: $viewModel.navigationPath) {
                MainScreenView(viewModel: viewModel)
                    .navigationDestination(for: Game.self) { game in
                        gameDestination(for: game)
                    }
            }

            if let type = bannerService.bannerType {
                BannerView(banner: type)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: bannerService.bannerType)
    }

    @ViewBuilder func gameDestination(for game: Game) -> some View {
        switch game.type {
        case .cardFlip:
            CardFlipGameView()
        case .reaction:
            ReactionGameView()
        case .colorMatch:
            ColorMatchGameView()
        }
    }
}
