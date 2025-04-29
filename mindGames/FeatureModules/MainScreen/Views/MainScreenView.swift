import SwiftUI

private enum Constants {
    static let navigationTitle = "Mind Games"
    static let achievementsSectionTitle = "Достижения"
    static let personIconSystemName = "person.circle.fill"
}

struct MainScreenView: View {
    
    @ObservedObject var viewModel: MainScreenViewModel
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.1).ignoresSafeArea(.all)
            
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
                        Image(systemName: Constants.personIconSystemName)
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
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
                    GameCell(gameType: game.type)
                        .onTapGesture {
                            viewModel.navigationPath.append(MainScreenDestination.game(game.type))
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
            Text(Constants.achievementsSectionTitle)
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            if viewModel.isLoadingAchievements {
                ForEach(0..<5, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 80)
                        .shimmer()
                }
            } else {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.achivements) { achievement in
                        AchievementCell(achievement: achievement)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    MainScreenView(viewModel: MainScreenViewModel())
}
