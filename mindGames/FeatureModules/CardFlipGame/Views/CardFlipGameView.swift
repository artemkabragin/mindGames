import SwiftUI

struct CardFlipGameView: View {
    
    @StateObject private var viewModel = CardFlipGameViewModel()
    @AppStorage("hasSeenCardFlipOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var showOnboarding = false
    
    var body: some View {
        ZStack {
            gameView
            
            if showOnboarding {
                onboardingView
            }
        }
        .onAppear {
            viewModel.startNewGame()
            if !hasSeenOnboarding {
                withAnimation {
                    showOnboarding = true
                }
            }
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

// MARK: - Onboarding View

private extension CardFlipGameView {
    var onboardingView: some View {
        Color.black.opacity(0.7)
            .edgesIgnoringSafeArea(.all)
            
            .overlay(
                VStack(spacing: 20) {
                    Text("Как играть в игру 'Парочки'")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("""
Найдите все пары одинаковых карточек, переворачивая их по очереди.

Игра заканчивается, когда вы найдете все совпадения или закончится время.
""")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
                    
                    Button(action: {
                        withAnimation {
                            showOnboarding = false
                            hasSeenOnboarding = true
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Понятно")
                                .foregroundColor(.white)
                                .padding()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .padding(.trailing)
                        }
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                    .padding()
            )
            .transition(.opacity)
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
    CardFlipGameView()
}
