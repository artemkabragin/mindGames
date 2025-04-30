import SwiftUI

private enum Constants {
    static let onboardingRoundCount = 3
}

final class ReactionGameViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    @Published var isGreen = false
    @Published var startTime: Date?
    @Published var reactionTime: Double?
    @Published var bestTime: Double?
    @Published var isPlaying = false
    @Published var showResult = false
    @Published var isOnboardingRoundsCompleted = false {
        didSet {
            if isOnboardingRoundsCompleted {
                Task {
                    await sendOnboardingResult()
                }
            }
        }
    }
    @Published var isShowOnboardingCompleted = false
    var onboardingAverage: Double = 0
    
    // MARK: - Private Properties
    
    private let achievementManager: AchievementManager = .shared
    private var roundCount: Int = 0
    private let onboardingRoundCount: Int?
    private var attempts: [Double] = []
    
    // MARK: - Init
    
    init() {
        if AppState.shared.showOnboarding {
            self.onboardingRoundCount = Constants.onboardingRoundCount
        } else {
            self.onboardingRoundCount = nil
        }
    }
    
    // MARK: - Public Methods
    
    func startGame() {
        guard AppState.shared.hasSeenReactionTutorial else { return }
        
        guard onboardingRoundCount != roundCount else {
            isOnboardingRoundsCompleted = true
            return
        }
        
        roundCount += 1
        isPlaying = true
        isGreen = false
        startTime = nil
        reactionTime = nil
        
        let delay = Double.random(in: 1...5)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
            if isPlaying {
                isGreen = true
                startTime = Date()
            }
        }
    }
    
    func stopGame() {
        isPlaying = false
        isGreen = false
    }
    
    func handleTap() {
        guard
            let startTime,
            isGreen
        else {
            return
        }
        
        let end = Date()
        reactionTime = end.timeIntervalSince(startTime)
        
        guard let reactionTime else { return }
        
        if bestTime == nil || reactionTime < bestTime! {
            bestTime = reactionTime
        }
        
        attempts.append(reactionTime)
        
        if !AppState.shared.showOnboarding {
            Task {
                let achievements = try? await GameService.shared.sendAttempt(
                    reactionTime,
                    gameType: .reaction
                )
                if let achievements {
                    achievementManager.processNewAchievements(achievements)
                }
            }
        }
        
        showResult = true
        isOnboardingRoundsCompleted = (onboardingRoundCount == roundCount)
        stopGame()
    }
    
    func sendOnboardingResult() async {
        guard let result = try? await GameService.shared.sendOnboardingAttempts(
            attempts,
            gameType: .reaction
        ) else {
            isShowOnboardingCompleted = false
            return
        }
        
        onboardingAverage = result.average
        
        await MainActor.run {
            isShowOnboardingCompleted = true
        }
    }
}
