import SwiftUI

struct ColorMatchGameView: View {
    
    @StateObject private var viewModel = ColorMatchGameViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Счёт: \(viewModel.score)")
                    .font(.title2)
                
                Spacer()
                
                Text("Время: \(viewModel.timeRemaining)")
                    .font(.title2)
            }
            .padding()
            
            Spacer()
            
            Text("Выберите цвет слова")
                .font(.title3)
                .padding()
            
            if let currentQuestion = viewModel.currentQuestion {
                Text(currentQuestion.name)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(currentQuestion.color)
                    .padding()
            }
            
            Spacer()
            Spacer()
            
            LazyVStack {
                ForEach(viewModel.currentAnswers) { answer in
                    Text(answer.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding()
                        .onTapGesture {
                            viewModel.checkAnswer(answer)
                        }
                }
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.startGame()
        }
        .alert("Игра окончена", isPresented: $viewModel.isGameOver) {
            Button("Сыграть еще?") {
                viewModel.startGame()
            }
        } message: {
            Text("Счет: \(viewModel.score)")
        }
    }
}

#Preview {
    ColorMatchGameView()
}
