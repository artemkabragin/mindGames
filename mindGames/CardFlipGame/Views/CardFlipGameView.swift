import SwiftUI

final class CardFlipGameViewModel: ObservableObject {
    @Published var cards: [Card] = []
    
    private var selectedCards: [Card] = []
    
    @Published var timeRemaining = 60
    @Published var timer: Timer?
    @Published var isGameOver = false
    @Published var isGameWin = false
    @Published var isTapEnabled = true
    var isNeedWait = true
    
    private let colors: [Color] = [
        .red,
        .blue,
        .green,
        .yellow,
        .purple,
        .orange
    ]
    
    func startNewGame() {
        var newCards: [Card] = []
        for color in colors {
            newCards.append(Card(color: color))
            newCards.append(Card(color: color))
        }
        cards = newCards.shuffled()
        timeRemaining = 60
        isGameOver = false
        
        // Start timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isGameOver = true
            }
        }
    }
    
    func handleCardTap(_ card: Card) {
//        guard isTapEnabled else { return }
        
        guard let index = cards.firstIndex(where: { $0.id == card.id }),
              !cards[index].isMatched else { return }
        
        withAnimation {
            cards[index].isSelected.toggle()
        }
        
        if cards[index].isSelected {
            selectedCards.append(cards[index])
        } else {
            selectedCards.removeAll { $0.id == card.id }
        }
        
        if selectedCards.count > 2 {
            if let first = selectedCards.first,
               let i = cards.firstIndex(where: { $0.id == first.id }) {
                cards[i].isSelected = false
            }
            selectedCards.removeFirst()
        }
        
        if selectedCards.count == 2 {
//            isTapEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [self] in
                approveOrRejectTwoCards()
            }
        }
    }
    
    func approveOrRejectTwoCards() {
        if selectedCards.hasSameColor() {
            for match in selectedCards {
                if let i = cards.firstIndex(where: { $0.id == match.id }) {
                    cards[i].isMatched = true
                }
            }
        } else {
            for unmatch in selectedCards {
                if let i = cards.firstIndex(where: { $0.id == unmatch.id }) {
                    cards[i].isMatched = false
                    cards[i].isSelected = false
                }
            }
        }
        selectedCards.removeAll()
//        isTapEnabled = true
    }
    
    func toggleIsSelected(_ card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }

        cards[index].isSelected.toggle()

        if cards[index].isSelected {
            selectedCards.append(cards[index])
        } else {
            selectedCards.removeAll { $0.id == card.id }
        }
    }
}

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
