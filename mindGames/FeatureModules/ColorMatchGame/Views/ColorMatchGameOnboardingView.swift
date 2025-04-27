import SwiftUI

private extension String {
    static let title = "Как играть в игру \"\(GameType.colorMatch.name)\""
    static let description = "Выберите из предложенных цвет, которым изображено слово, как можно быстрее."
    static let buttonTitle = "Понятно"
}

struct ColorMatchGameOnboardingView: View {
    
    @ObservedObject var viewModel: ColorMatchGameViewModel
    
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

private extension ColorMatchGameOnboardingView {
    var contentView: some View {
        VStack(
            alignment: .center,
            spacing: 20
        ) {
            titleView
            Spacer()
            descriptionView
            Spacer()
            nextButton
        }
        .padding()
    }
}

// MARK: - Title

private extension ColorMatchGameOnboardingView {
    var titleView: some View {
        Text(String.title)
            .font(.title)
            .bold()
            .foregroundColor(.white)
    }
}

// MARK: - Description

private extension ColorMatchGameOnboardingView {
    var descriptionView: some View {
        Text(String.description)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding()
    }
}

// MARK: - Next Button

private extension ColorMatchGameOnboardingView {
    var nextButton: some View {
        Button(action: {
            withAnimation {
                viewModel.hasSeenTutorial = true
                viewModel.startGame()
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
    ColorMatchGameOnboardingView(viewModel: ColorMatchGameViewModel())
}
