import SwiftUI

private enum Constants {
    static let colors: [Color] = [
        .red,
        .blue,
        .green,
        .yellow,
//        .purple,
//        .orange
    ]
    
    static let time: Int = 60
}

enum GameSource {
    case onboarding
    case `default`
}

//class OnboardingGameViewModel {
//    
//    // MARK: - Public Properties
//    
//    @Published var isOnboardingRoundsCompleted = false
//    
//    // MARK: - Private Properties
//    
//    private let onboardingRoundCount: Int
//    private var roundCount: Int = 0
//    
//    // MARK: - Init
//    
//    init(onboardingRoundCount: Int) {
//        self.onboardingRoundCount = onboardingRoundCount
//    }
//    
//    func startNewGame() {
//        
//    }
//}

struct OnboardingGameResult {
    let gameType: GameType
    let result: Int
}

final class OnboardingGameResultCalculator {
    
    static let shared = OnboardingGameResultCalculator()
    
    func calculateResult(
        gameType: GameType,
        attempts: [Int]
    ) -> Int {
        let sum = attempts.reduce(0, +)
        let count = attempts.count
        
        guard count > 0 else { return 0 }
        
        return sum / count
    }
}

final class CardFlipGameViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    @AppStorage("hasSeenCardFlipTutorial") var hasSeenTutorial: Bool = false
    @Published var cards: [Card] = []
    @Published var timeRemaining = 60
    @Published var isGameOver = false
    @Published var isGameWin = false
    private var roundCount: Int = 0
    var attempts: [Int] = []
    
    @Published var isOnboardingRoundsCompleted = false
    
    let onboardingRoundCount: Int?
    private let onboardingGameResultCalculator = OnboardingGameResultCalculator.shared
    
    init(onboardingRoundCount: Int? = nil) {
        self.onboardingRoundCount = onboardingRoundCount
        hasSeenTutorial = false
    }
    // MARK: - Private Properties
    
    private var selectedCards: [Card] = []
    private var matchCheckWorkItem: DispatchWorkItem?
    private var timer: Timer?
    
    // MARK: - Public Methods
    
    func startNewGame() {
        cards = getCards()
        
        guard hasSeenTutorial else { return }
        
        guard onboardingRoundCount != roundCount else {
            isOnboardingRoundsCompleted = true
            return
        }
        
        roundCount += 1
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
            attempts.append(timeRemaining)
        }
        
        if let onboardingRoundCount {
            isOnboardingRoundsCompleted = (onboardingRoundCount == roundCount) && isGameWin
        } else {
            self.isGameWin = isGameWin
        }
    }
}
