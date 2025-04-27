import SwiftUI

private enum Constants {
    static let navigationTitle = "Mind Games"
}

struct MainScreenView: View {
    
    @ObservedObject var viewModel: MainScreenViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                gamesSection
                achievementsSection
            }
        }
        .task {
            await viewModel.getAchievements()
        }
        .navigationTitle(Constants.navigationTitle)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    viewModel.navigationPath.append(MainScreenDestination.person)
                }) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
        }
    }
}

// MARK: - Games Section

private extension MainScreenView {
    var gamesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(Game.games) { game in
                    GameCell(game: game)
                        .onTapGesture {
                            viewModel.navigationPath.append(MainScreenDestination.game(game))
                        }
                }
            }
            .padding()
        }
    }
}

// MARK: - Achievements Section

private extension MainScreenView {
    var achievementsSection: some View {
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
