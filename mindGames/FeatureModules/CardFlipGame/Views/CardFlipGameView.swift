import SwiftUI

struct CardFlipGameView: View {
    
    @StateObject private var viewModel = CardFlipGameViewModel(onboardingRoundCount: 1)
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        ZStack {
            gameView
            
            if !viewModel.hasSeenTutorial {
                CardFlipGameOnboardingView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.startNewGame()
        }
        .alert("Тестирование завершено", isPresented: $viewModel.isOnboardingRoundsCompleted) {
            Button("Далее") {
                onboardingViewModel.navigationPath.append(OnboardingScreen.reaction)
            }
        } message: {
            let result = OnboardingGameResultCalculator.shared.calculateResult(gameType: .cardFlip, attempts: viewModel.attempts)
            Text("Ваш средний результат - \(result).")
        }
        .alert("Игра окончена", isPresented: $viewModel.isGameOver) {
            Button("Сыграть еще?") {
                viewModel.startNewGame()
            }
        } message: {
            Text("Попробуйте еще, не сдавайтесь.")
        }
        .alert("Вы выиграли!", isPresented: $viewModel.isGameWin) {
            Button("Сыграть еще?") {
                viewModel.startNewGame()
            }
        } message: {
            Text("Так держать!")
        }
    }
}

// MARK: - Game View

private extension CardFlipGameView {
    var gameView: some View {
        VStack {
            HStack {
                Text("Оставшееся время: \(viewModel.timeRemaining)")
                    .font(.title2)
                    .padding()
                
                Spacer()
                
                Button("Начать заново") {
                    viewModel.startNewGame()
                }
                .padding()
            }
            
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 80))
            ], spacing: 10) {
                ForEach(viewModel.cards, id: \.id) { card in
                    CardView(card: card)
                        .onTapGesture {
                            viewModel.handleCardTap(card)
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    CardFlipGameView(onboardingViewModel: OnboardingViewModel())
}
