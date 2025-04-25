import SwiftUI

private enum Constants {
    static let nextButtonText: String = "Начать"
    static let onboardingDescription: String = """
            Доброго времени суток!
            
            Это приложение предназначено для тренировок памяти и внимания.
            
            Чтобы Вы могли видеть ваш прогресс, предлагаем пройти тестирование, в ходе которого мы зафиксируем Ваши начальные показатели!
            """
}

struct OnboardingHelloScreenView: View {
    
    @StateObject var viewModel = OnboardingViewModel()
    
    var body: some View {
        
        NavigationStack(path: $viewModel.navigationPath) {
            VStack {
                Spacer()
                descriptionView
                Spacer()
                nextButton
            }
            .padding()
            .navigationTitle("Mind Games")
            .navigationDestination(for: OnboardingScreen.self) { screen in
                viewModel.destination(for: screen)
            }
        }
    }
}

// MARK: - Description View

private extension OnboardingHelloScreenView {
    var descriptionView: some View {
        Text(Constants.onboardingDescription)
            .font(.title2)
            .bold()
            .multilineTextAlignment(.center)
            .padding()
    }
}

// MARK: - Next Button

private extension OnboardingHelloScreenView {
    var nextButton: some View {
        Button(action: {
            viewModel.navigationPath.append(OnboardingScreen.cardFlipTutorial)
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
