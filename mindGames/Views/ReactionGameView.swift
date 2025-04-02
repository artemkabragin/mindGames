import SwiftUI

struct ReactionGameView: View {
    @State private var isGreen = false
    @State private var startTime: Date?
    @State private var reactionTime: Double?
    @State private var bestTime: Double?
    @State private var isPlaying = false
    @State private var showResult = false
    
    var body: some View {
        VStack {
            Text("Best Time: \(bestTime?.formatted() ?? "N/A")")
                .font(.title2)
                .padding()
            
            Spacer()
            
            Circle()
                .fill(isGreen ? Color.green : Color.red)
                .frame(width: 200, height: 200)
                .onTapGesture {
                    if isGreen {
                        handleTap()
                    }
                }
            
            Spacer()
            
            Button(isPlaying ? "Stop" : "Start") {
                if isPlaying {
                    stopGame()
                } else {
                    startGame()
                }
            }
            .font(.title2)
            .padding()
            .background(isPlaying ? Color.red : Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .alert("Your Reaction Time", isPresented: $showResult) {
            Button("OK") {
                showResult = false
            }
        } message: {
            if let time = reactionTime {
                Text("\(time.formatted()) seconds")
            }
        }
    }
    
    private func startGame() {
        isPlaying = true
        isGreen = false
        startTime = nil
        reactionTime = nil
        
        let delay = Double.random(in: 1...5)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if isPlaying {
                isGreen = true
                startTime = Date()
            }
        }
    }
    
    private func stopGame() {
        isPlaying = false
        isGreen = false
    }
    
    private func handleTap() {
        guard let start = startTime else { return }
        
        let end = Date()
        let time = end.timeIntervalSince(start)
        reactionTime = time
        
        if bestTime == nil || time < bestTime! {
            bestTime = time
        }
        
        isGreen = false
        showResult = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if isPlaying {
                startGame()
            }
        }
    }
}

#Preview {
    ReactionGameView()
} 
