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
    static let time = 5
}

final class ColorMatchGameViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    @AppStorage("hasSeenColorMatchTutorial") var hasSeenTutorial: Bool = false
    @Published var score = 0
    @Published var timeRemaining = Constants.time
    @Published var isGameOver = false
    @Published var showResult = false
    @Published var currentAnswers: [ColorAnswer] = []
    @Published var currentQuestion: ColorQuestion?
    @Published var isOnboardingRoundsCompleted = false
    private var roundCount: Int = 0
    var attempts: [Double] = []
    
    // MARK: - Private Properties
    
    private var timer: Timer?
    private let onboardingRoundCount: Int?
    
    // MARK: - Init
    
    init(onboardingRoundCount: Int? = nil) {
        self.onboardingRoundCount = onboardingRoundCount
        hasSeenTutorial = false
    }
    
    // MARK: - Public Methods
    
    func startGame() {
        startNewRound()
        
        guard hasSeenTutorial else { return }
        
        guard onboardingRoundCount != roundCount else {
            isOnboardingRoundsCompleted = true
            return
        }
        
        roundCount += 1
        score = 0
        timeRemaining = Constants.time
        isGameOver = false
        
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                attempts.append(Double(score))
                if onboardingRoundCount == roundCount {
                    isOnboardingRoundsCompleted = true
                } else {
                    isGameOver = true
                }
                stopTimer()
            }
        }
        
        startNewRound()
    }
    
    func checkAnswer(_ selectedAnswer: ColorAnswer) {
        if selectedAnswer.name == currentQuestion?.color.getName() {
            score += 1
        }
        
        startNewRound()
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
}

// MARK: - Private Methods

private extension ColorMatchGameViewModel {
    func startNewRound() {
        guard
            let randomColor = Constants.colors.randomElement(),
            let randomColorName = Constants.colors.filter({ $0 != randomColor }).randomElement()?.getName()
        else {
            return
        }
        
        currentQuestion = ColorQuestion(
            name: randomColorName,
            color: randomColor
        )
        
        var answers = Constants.colors
            .filter { $0 != randomColor }
            .shuffled()
            .map { ColorAnswer(color: $0) }
            .prefix(3)
            
        answers.append(ColorAnswer(color: randomColor))
        
        currentAnswers = answers.shuffled()
    }
}
