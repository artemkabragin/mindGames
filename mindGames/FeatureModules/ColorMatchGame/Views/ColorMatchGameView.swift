import SwiftUI

struct ColorMatchGameView: View {
    
    @StateObject private var viewModel = ColorMatchGameViewModel()
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    let onboardingGameResultCalculator = OnboardingGameResultCalculator.shared
    
    var body: some View {
        ZStack {
            gameView
            
            if !AppState.shared.hasSeenColorMatchTutorial {
                ColorMatchGameOnboardingView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.startGame()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
        .alert(
            "Тестирование завершено",
            isPresented: $viewModel.isOnboardingRoundsCompleted
        ) {
            Button("Далее") {
                onboardingViewModel.navigationPath.append(OnboardingDestination.finish)
            }
        } message: {
            let result = onboardingGameResultCalculator.calculateResult(
                gameType: .colorMatch,
                attempts: viewModel.attempts
            )
            Text("Ваш средний результат - \(Int(result)).")
        }
        .alert(
            "Игра окончена",
            isPresented: $viewModel.isGameOver
        ) {
            Button("Сыграть еще?") {
                viewModel.startGame()
            }
        } message: {
            Text("Счет: \(viewModel.score)")
        }
    }
}

// MARK: - Game view

private extension ColorMatchGameView {
    var gameView: some View {
        VStack {
            HStack {
                Text("Счёт: \(viewModel.score)")
                    .font(.title2)
                
                Spacer()
                
                Text("Время: \(viewModel.timeRemaining)")
                    .font(.title2)
            }
            .padding()
            
            Spacer()
            
            Text("Выберите цвет слова")
                .font(.title3)
                .padding()
            
            if let currentQuestion = viewModel.currentQuestion {
                Text(currentQuestion.name)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(currentQuestion.color)
                    .padding()
            }
            
            Spacer()
            Spacer()
            
            LazyVStack {
                ForEach(viewModel.currentAnswers) { answer in
                    Text(answer.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding()
                        .onTapGesture {
                            viewModel.checkAnswer(answer)
                        }
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    ColorMatchGameView(onboardingViewModel: OnboardingViewModel())
}
