import SwiftUI

struct MainScreenView: View {
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(Game.games) { game in
                        GameCell(game: game)
                            .onTapGesture {
                                navigationPath.append(game)
                            }
                    }
                }
                .padding()
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
