import SwiftUI

struct ReactionGameView: View {
    
    // MARK: - Private Properties
    
    @ObservedObject var appState: AppState = .shared
    @StateObject private var viewModel: ReactionGameViewModel = ReactionGameViewModel()
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        ZStack {
            gameView
            
            if !appState.hasSeenReactionTutorial {
                ReactionGameOnboardingView(viewModel: viewModel)
            }
        }
        .alert("Время вашей реакции", isPresented: $viewModel.showResult) {
            Button("OK") {
                viewModel.showResult = false
            }
        } message: {
            if let time = viewModel.reactionTime {
                Text("\(time.formatted()) секунд")
            }
        }
        .alert("Тестирование завершено", isPresented: $viewModel.isOnboardingRoundsCompleted) {
            Button("Далее") {
                onboardingViewModel.navigationPath.append(OnboardingDestination.colorMatch)
            }
        }
    }
}

// MARK: - Game

private extension ReactionGameView {
    var gameView: some View {
        VStack {
            Spacer()
            
            Circle()
                .fill(viewModel.isGreen ? Color.green : Color.red)
                .frame(width: 200, height: 200)
                .onTapGesture {
                    viewModel.handleTap()
                }
            
            Spacer()
            
            Button(viewModel.isPlaying ? "Остановить" : "Начать") {
                if viewModel.isPlaying {
                    viewModel.stopGame()
                } else {
                    viewModel.startGame()
                }
            }
            .font(.title2)
            .padding()
            .background(viewModel.isPlaying ? Color.red : Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
    }
}

#Preview {
    ReactionGameView(onboardingViewModel: OnboardingViewModel())
}
