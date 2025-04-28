import SwiftUI

private enum Constants {
    static let colors: [Color] = [
        .red,
//        .blue,
//        .green,
//        .yellow,
//        .purple,
//        .orange
    ]
    
    static let time: Int = 5
    static let onboardingRoundCount = 1
}

final class CardFlipGameViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    
    @Published var cards: [Card] = []
    @Published var timeRemaining = Constants.time
    @Published var isGameOver = false
    @Published var isGameWin = false
    
    var attempts: [Double] = []
    
    @Published var isOnboardingRoundsCompleted = false {
        didSet {
            if isOnboardingRoundsCompleted {
                Task {
                    await sendOnboardingResult()
                }
            }
        }
    }
    
    let onboardingRoundCount: Int?
    
    // MARK: - Private Properties
    
    private var selectedCards: [Card] = []
    private var matchCheckWorkItem: DispatchWorkItem?
    private var roundCount: Int = 0
    private var timer: Timer?
    
    // MARK: - Init
    
    init() {
        if AppState.shared.showOnboarding {
            self.onboardingRoundCount = Constants.onboardingRoundCount
        } else {
            self.onboardingRoundCount = nil
        }
    }
    
    // MARK: - Public Methods
    
    func startNewGame() {
        cards = getCards()
        
        guard AppState.shared.hasSeenCardFlipTutorial else { return }
        
        guard onboardingRoundCount != roundCount else {
            isOnboardingRoundsCompleted = true
            return
        }
        
        roundCount += 1
        timeRemaining = Constants.time
        isGameOver = false
        selectedCards.removeAll()
        
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isGameOver = true
                stopTimer()
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
    
    func stopTimer() {
        timer?.invalidate()
    }
}

// MARK: - Private Methods

private extension CardFlipGameViewModel {
    func getCards() -> [Card] {
        var newCards: [Card] = []
        for color in Constants.colors {
            newCards.append(Card(color: color))
            newCards.append(Card(color: color))
        }
        return newCards.shuffled()
    }
    
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
        
        let isGameWin = cards.allSatisfy { $0.isMatched }
        
        if isGameWin {
            let doubleTime = Double(timeRemaining)
            attempts.append(doubleTime)
            if !AppState.shared.showOnboarding {
                Task {
                    try? await GameService.shared.sendAttempt(
                        doubleTime,
                        gameType: .cardFlip
                    )
                }
            }
        }
        
        if let onboardingRoundCount {
            isOnboardingRoundsCompleted = (onboardingRoundCount == roundCount) && isGameWin
        } else {
            self.isGameWin = isGameWin
        }
    }
    
    func sendOnboardingResult() async {
        let result = try? await GameService.shared.sendOnboardingAttempts(
            attempts,
            gameType: .cardFlip
        )
        print("Onboarding result in \(GameType.cardFlip) - \(result ?? 0)")
    }
}
