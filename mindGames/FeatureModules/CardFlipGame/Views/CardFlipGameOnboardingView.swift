import SwiftUI

private extension String {
    static let title = "Как играть в игру \"\(GameType.cardFlip.name)\""
    static let description = """
Найдите все пары одинаковых карточек, переворачивая их по очереди.

Игра заканчивается, когда вы найдете все совпадения или закончится время.
"""
    static let buttonTitle = "Понятно"
}

struct CardFlipGameOnboardingView: View {
    
    @ObservedObject var viewModel: CardFlipGameViewModel
    
    var body: some View {
        Color.black.opacity(0.85)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                contentView
            )
            .transition(.opacity)
    }
}

// MARK: - Content

private extension CardFlipGameOnboardingView {
    var contentView: some View {
        VStack(
            alignment: .center,
            spacing: 20
        ) {
            titleView
            Spacer()
            descriptionView
            nextButton
        }
        .padding()
    }
}


// MARK: - Title

private extension CardFlipGameOnboardingView {
    var titleView: some View {
        Text(String.title)
            .font(.title)
            .bold()
            .foregroundColor(.white)
    }
}

// MARK: - Description

private extension CardFlipGameOnboardingView {
    var descriptionView: some View {
        Text(String.description)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding()
    }
}

// MARK: - Next Button

private extension CardFlipGameOnboardingView {
    var nextButton: some View {
        Button(action: {
            withAnimation {
                AppState.shared.hasSeenCardFlipTutorial = true
                viewModel.startNewGame()
            }
        }) {
            HStack {
                Spacer()
                Text(String.buttonTitle)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Image(systemName: "arrow.right")
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    CardFlipGameOnboardingView(viewModel: CardFlipGameViewModel())
}
