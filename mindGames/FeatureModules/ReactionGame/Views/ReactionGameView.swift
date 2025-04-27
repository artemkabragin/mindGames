import SwiftUI

struct ReactionGameView: View {
    
    // MARK: - Private Properties
    
    @StateObject private var viewModel: ReactionGameViewModel = ReactionGameViewModel()
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    let onboardingGameResultCalculator = OnboardingGameResultCalculator.shared
    
    var body: some View {
        ZStack {
            gameView
            
            if !AppState.shared.hasSeenReactionTutorial {
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
                onboardingViewModel.navigationPath.append(OnboardingScreen.colorMatch)
            }
        } message: {
            let result = onboardingGameResultCalculator.calculateResult(
                gameType: .reaction,
                attempts: viewModel.attempts
            )
            Text("Ваш средний результат - \(result).")
        }
    }
}

// MARK: - Game

private extension ReactionGameView {
    var gameView: some View {
        VStack {
            Text("Лучшее время: \(viewModel.bestTime?.formatted() ?? "N/A")")
                .font(.title2)
                .padding()
            
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
