import SwiftUI

struct ColorMatchGameView: View {
    @State private var currentRound = 0
    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var timer: Timer?
    @State private var isGameOver = false
    @State private var showResult = false
    
    struct ColorOption: Identifiable {
        let id = UUID()
        let name: String
        let color: Color
    }
    
    let colors: [(name: String, color: Color)] = [
        ("Red", .red),
        ("Blue", .blue),
        ("Green", .green),
        ("Yellow", .yellow),
        ("Purple", .purple),
        ("Orange", .orange)
    ]
    
    var currentQuestion: ColorOption {
        let correctColor = colors[currentRound]
        return ColorOption(name: correctColor.name, color: correctColor.color)
    }
    
    var options: [ColorOption] {
        var allOptions = colors.map { ColorOption(name: $0.name, color: $0.color) }
        allOptions.remove(at: currentRound)
        return Array(allOptions.shuffled().prefix(3))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Score: \(score)")
                    .font(.title2)
                
                Spacer()
                
                Text("Time: \(timeRemaining)")
                    .font(.title2)
            }
            .padding()
            
            Spacer()
            
            Text("Select the color that matches the name:")
                .font(.title3)
                .padding()
            
            Text(currentQuestion.name)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(currentQuestion.color)
                .padding()
            
            Spacer()
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                ForEach(options) { option in
                    Button(action: {
                        checkAnswer(option)
                    }) {
                        VStack {
                            Circle()
                                .fill(option.color)
                                .frame(width: 100, height: 100)
                            
                            Text(option.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            startGame()
        }
        .alert("Game Over", isPresented: $isGameOver) {
            Button("Play Again") {
                startGame()
            }
        } message: {
            Text("Final Score: \(score)")
        }
    }
    
    private func startGame() {
        currentRound = 0
        score = 0
        timeRemaining = 30
        isGameOver = false
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isGameOver = true
            }
        }
    }
    
    private func checkAnswer(_ selectedOption: ColorOption) {
        if selectedOption.name == currentQuestion.name {
            score += 1
        }
        
        if currentRound < colors.count - 1 {
            currentRound += 1
        } else {
            isGameOver = true
        }
    }
}

#Preview {
    ColorMatchGameView()
} 