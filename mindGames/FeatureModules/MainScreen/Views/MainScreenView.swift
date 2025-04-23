import SwiftUI

struct MainScreenView: View {
    @EnvironmentObject var bannerService: BannerService
    @ObservedObject var viewModel: MainScreenViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        ForEach(Game.games) { game in
                            GameCell(game: game)
                                .onTapGesture {
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
        .task {
            await viewModel.getAchievements()
        }
        .navigationTitle("Mind Games")
    }
}
