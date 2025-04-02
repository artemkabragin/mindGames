import SwiftUI

struct CardFlipGameView: View {
    @State private var cards: [Card] = []
    @State private var selectedCards: Set<UUID> = []
    @State private var matchedPairs: Set<UUID> = []
    @State private var timeRemaining = 60
    @State private var timer: Timer?
    @State private var isGameOver = false
    
    struct Card: Identifiable {
        let id = UUID()
        let color: Color
        var isFlipped = false
    }
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]
    
    var body: some View {
        VStack {
            HStack {
                Text("Time: \(timeRemaining)")
                    .font(.title2)
                    .padding()
                
                Spacer()
                
                Button("Restart") {
                    startNewGame()
                }
                .padding()
            }
            
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 80))
            ], spacing: 10) {
                ForEach(cards) { card in
                    CardView(card: card, isSelected: selectedCards.contains(card.id))
                        .onTapGesture {
                            handleCardTap(card)
                        }
                }
            }
            .padding()
        }
        .onAppear {
            startNewGame()
        }
        .alert("Game Over", isPresented: $isGameOver) {
            Button("Play Again") {
                startNewGame()
            }
        } message: {
            Text("Time's up! Try again to match all the cards.")
        }
    }
    
    private func startNewGame() {
        // Create pairs of cards
        var newCards: [Card] = []
        for color in colors {
            newCards.append(Card(color: color))
            newCards.append(Card(color: color))
        }
        cards = newCards.shuffled()
        selectedCards.removeAll()
        matchedPairs.removeAll()
        timeRemaining = 60
        isGameOver = false
        
        // Start timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isGameOver = true
            }
        }
    }
    
    private func handleCardTap(_ card: Card) {
        guard !matchedPairs.contains(card.id) else { return }
        
        if selectedCards.count == 2 {
            // Check if the selected cards match
            let selectedCardsArray = cards.filter { selectedCards.contains($0.id) }
            if selectedCardsArray[0].color == selectedCardsArray[1].color {
                // Match found
                matchedPairs.insert(selectedCardsArray[0].id)
                matchedPairs.insert(selectedCardsArray[1].id)
            }
            selectedCards.removeAll()
        }
        
        selectedCards.insert(card.id)
    }
}

struct CardView: View {
    let card: CardFlipGameView.Card
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? card.color : Color.gray.opacity(0.3))
                .frame(height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
        }
    }
}

#Preview {
    CardFlipGameView()
} 