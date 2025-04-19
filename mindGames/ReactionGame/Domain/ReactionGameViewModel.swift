import SwiftUI

final class ReactionGameViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    @Published var isGreen = false
    @Published var startTime: Date?
    @Published var reactionTime: Double?
    @Published var bestTime: Double?
    @Published var isPlaying = false
    @Published var showResult = false
    
    // MARK: - Public Methods
    
    func startGame() {
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
        let time = end.timeIntervalSince(startTime)
        reactionTime = time
        
        if bestTime == nil || time < bestTime! {
            bestTime = time
        }
        
        isGreen = false
        showResult = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            if isPlaying {
                startGame()
            }
        }
    }
}
