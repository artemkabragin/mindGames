import SwiftUI

struct CardFlipGameView: View {
        
    @StateObject private var viewModel = CardFlipGameViewModel()
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        ZStack {
            gameView
            
            if !AppState.shared.hasSeenCardFlipTutorial {
                CardFlipGameOnboardingView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.startNewGame()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
        .alert(
            "Тестирование завершено",
            isPresented: $viewModel.isShowOnboardingCompleted
        ) {
            Button("Далее") {
                onboardingViewModel.navigationPath.append(OnboardingDestination.reaction)
            }
        } message: {
            let result = viewModel.onboardingAverage
            Text("Ваш средний результат - \(Int(result)).")
        }
        .alert(
            "Игра окончена",
            isPresented: $viewModel.isGameOver
        ) {
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
