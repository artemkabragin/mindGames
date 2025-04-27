final class OnboardingGameResultCalculator {
    
    static let shared = OnboardingGameResultCalculator()
    
    func calculateResult(
        gameType: GameType,
        attempts: [Double]
    ) -> Double {
        let sum = attempts.reduce(0, +)
        let count = attempts.count
        
        guard count > 0 else { return 0 }
        
        return sum / Double(count)
    }
}
