import SwiftUI

private enum Constants {
    static let nextButtonText: String = "Отлично!"
    static let description: String = """
            Вы прошли стартовое тестирование!
            
            Чтобы отслеживать свой прогресс, перейдите в личный кабинет.
            """
}

struct OnboardingFinishScreenView: View {
        
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            Spacer()
            descriptionView
            Spacer()
            nextButton
        }
        .padding()
    }
}

// MARK: - Description View

private extension OnboardingFinishScreenView {
    var descriptionView: some View {
        Text(Constants.description)
            .font(.title2)
            .bold()
            .multilineTextAlignment(.center)
            .padding()
    }
}

// MARK: - Next Button

private extension OnboardingFinishScreenView {
    var nextButton: some View {
        Button(action: {
            appState.showOnboarding = false
        }) {
            HStack {
                Spacer()
                Text(Constants.nextButtonText)
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
