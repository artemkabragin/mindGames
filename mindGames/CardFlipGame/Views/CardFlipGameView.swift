import SwiftUI

struct CardFlipGameView: View {
    
    @StateObject private var viewModel = CardFlipGameViewModel()
    
    var body: some View {
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
        .onAppear {
            viewModel.startNewGame()
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

#Preview {
    CardFlipGameView()
}
