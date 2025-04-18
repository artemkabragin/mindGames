import SwiftUI



struct CardFlipGameView: View {
    
    @StateObject private var viewModel = CardFlipGameViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Time: \(viewModel.timeRemaining)")
                    .font(.title2)
                    .padding()
                
                Spacer()
                
                Button("Restart") {
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
        .alert("Game Over", isPresented: $viewModel.isGameOver) {
            Button("Play Again") {
                viewModel.startNewGame()
            }
        } message: {
            Text("Time's up! Try again to match all the cards.")
        }
    }
}

#Preview {
    CardFlipGameView()
}
