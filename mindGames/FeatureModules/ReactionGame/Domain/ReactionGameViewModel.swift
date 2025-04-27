import SwiftUI

final class ReactionGameViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    @Published var isGreen = false
    @Published var startTime: Date?
    @Published var reactionTime: Double?
    @Published var bestTime: Double?
    @Published var isPlaying = false
    @Published var showResult = false
    @Published var isOnboardingRoundsCompleted = false
    @AppStorage("hasSeenReactionTutorial") var hasSeenTutorial: Bool = false
    
    // MARK: - Private Properties
    
    private var achievementManager: AchievementManager
    private var roundCount: Int = 0
    let onboardingRoundCount: Int?
    var attempts: [Double] = []
    
    // MARK: - Init
    
    init(
        achievementManager: AchievementManager = .shared,
        onboardingRoundCount: Int? = nil
    ) {
        self.achievementManager = achievementManager
        self.onboardingRoundCount = onboardingRoundCount
        hasSeenTutorial = false
    }
    
    // MARK: - Public Methods
    
    func startGame() {
        guard hasSeenTutorial else { return }
        
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
        
        achievementManager.updateAchievement(
            for: .reaction,
            action: .gamePlayed
        )
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
        
        achievementManager.updateAchievement(
            for: .reaction,
            action: .newRecord(reactionTime)
        )
        
        if bestTime == nil || reactionTime < bestTime! {
            bestTime = reactionTime
        }
        
        attempts.append(reactionTime)
        
        showResult = true
        isOnboardingRoundsCompleted = (onboardingRoundCount == roundCount)
        stopGame()
    }
}
