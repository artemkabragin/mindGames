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
}

final class ColorMatchGameViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    @Published var score = 0
    @Published var timeRemaining = 30
    @Published var isGameOver = false
    @Published var showResult = false
    @Published var currentAnswers: [ColorAnswer] = []
    @Published var currentQuestion: ColorQuestion?
    
    // MARK: - Private Properties
    
    private var timer: Timer?
    
    // MARK: - Public Methods
    
    func startGame() {
        score = 0
        timeRemaining = 30
        isGameOver = false
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isGameOver = true
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
