import SwiftUI

struct ReactionGameView: View {
    
    @StateObject private var viewModel = ReactionGameViewModel()
    
    var body: some View {
        VStack {
            Text("Лучшее время: \(viewModel.bestTime?.formatted() ?? "N/A")")
                .font(.title2)
                .padding()
            
            Spacer()
            
            Circle()
                .fill(viewModel.isGreen ? Color.green : Color.red)
                .frame(width: 200, height: 200)
                .onTapGesture {
                    viewModel.handleTap()
                }
            
            Spacer()
            
            Button(viewModel.isPlaying ? "Остановить" : "Начать") {
                if viewModel.isPlaying {
                    viewModel.stopGame()
                } else {
                    viewModel.startGame()
                }
            }
            .font(.title2)
            .padding()
            .background(viewModel.isPlaying ? Color.red : Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .alert("Время вашей реакции", isPresented: $viewModel.showResult) {
            Button("OK") {
                viewModel.showResult = false
            }
        } message: {
            if let time = viewModel.reactionTime {
                Text("\(time.formatted()) секунд")
            }
        }
    }
}

#Preview {
    ReactionGameView()
}
