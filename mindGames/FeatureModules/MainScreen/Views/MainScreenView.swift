import SwiftUI

struct MainScreenView: View {
    @StateObject private var viewModel: MainScreenViewModel
    
    init(
        viewModel: MainScreenViewModel = MainScreenViewModel()
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ScrollView {
                VStack(spacing: 20) {
                    // Games Section
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 20) {
                            ForEach(Game.games) { game in
                                GameCell(game: game)
                                    .onTapGesture {
                                        viewModel.selectedGame = game
                                        viewModel.navigationPath.append(game)
                                    }
                            }
                        }
                        .padding()
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Achievements")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        
                        ForEach(viewModel.achivements) { achievement in
                            AchievementCell(achievement: achievement)
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                Task {
                    await viewModel.getAchievements()
                }
            }
            .navigationTitle("Mind Games")
            .navigationDestination(for: Game.self) { game in
                gameDestination(for: game)
            }
        }
    }
    
    @ViewBuilder
    private func gameDestination(for game: Game) -> some View {
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

#Preview {
    MainScreenView()
}
