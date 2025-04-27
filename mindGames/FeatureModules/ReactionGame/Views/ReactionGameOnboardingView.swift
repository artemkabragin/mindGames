import SwiftUI

private extension String {
    static let title = "Как играть в игру \"\(GameType.reaction.name)\""
    static let description = "Нажмите на круг, когда он станет зеленым, как можно быстрее."
    static let buttonTitle = "Понятно"
}

struct ReactionGameOnboardingView: View {
    
    @ObservedObject var viewModel: ReactionGameViewModel
    
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

private extension ReactionGameOnboardingView {
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

private extension ReactionGameOnboardingView {
    var titleView: some View {
        Text(String.title)
            .font(.title)
            .bold()
            .foregroundColor(.white)
    }
}

// MARK: - Description

private extension ReactionGameOnboardingView {
    var descriptionView: some View {
        Text(String.description)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding()
    }
}

// MARK: - Next Button

private extension ReactionGameOnboardingView {
    var nextButton: some View {
        Button(action: {
            withAnimation {
                AppState.shared.hasSeenReactionTutorial = true
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
    ReactionGameOnboardingView(viewModel: ReactionGameViewModel())
}
