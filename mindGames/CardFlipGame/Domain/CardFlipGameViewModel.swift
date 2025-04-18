import SwiftUI

private enum Constants {
    static let colors: [Color] = [
        .red,
        .blue,
        .green,
        .yellow,
        .purple,
        .orange
    ]
    
    static let time: Int = 60
}

final class CardFlipGameViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    @Published var cards: [Card] = []
    @Published var timeRemaining = 60
    @Published var isGameOver = false
    @Published var isGameWin = false
    
    // MARK: - Private Properties
    
    private var selectedCards: [Card] = []
    private var matchCheckWorkItem: DispatchWorkItem?
    private var timer: Timer?
    
    // MARK: - Public Methods
    
    func startNewGame() {
        var newCards: [Card] = []
        for color in Constants.colors {
            newCards.append(Card(color: color))
            newCards.append(Card(color: color))
        }
        cards = newCards.shuffled()
        timeRemaining = Constants.time
        isGameOver = false
        selectedCards.removeAll()
        
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
        guard
            let tappedIndex = cards.firstIndex(where: { $0.id == card.id }),
            !cards[tappedIndex].isMatched,
            !cards[tappedIndex].isSelected
        else { return }
        
        if selectedCards.count == 2 {
            matchCheckWorkItem?.cancel()
            evaluateSelectedCardsImmediately()
        }
        
        cards[tappedIndex].isSelected = true
        selectedCards.append(cards[tappedIndex])
        
        if selectedCards.count == 2 {
            let workItem = DispatchWorkItem { [weak self] in
                self?.evaluateSelectedCardsImmediately()
            }
            matchCheckWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: workItem)
        }
    }
}

// MARK: - Private Methods

private extension CardFlipGameViewModel {
    func evaluateSelectedCardsImmediately() {
        guard selectedCards.count == 2 else { return }
        
        let first = selectedCards[0]
        let second = selectedCards[1]
        
        if first.color == second.color {
            if let firstIndex = cards.firstIndex(where: { $0.id == first.id }) {
                cards[firstIndex].isMatched = true
            }
            if let secondIndex = cards.firstIndex(where: { $0.id == second.id }) {
                cards[secondIndex].isMatched = true
            }
        } else {
            if let firstIndex = cards.firstIndex(where: { $0.id == first.id }) {
                cards[firstIndex].isSelected = false
            }
            if let secondIndex = cards.firstIndex(where: { $0.id == second.id }) {
                cards[secondIndex].isSelected = false
            }
        }
        
        selectedCards.removeAll()
        matchCheckWorkItem = nil
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
