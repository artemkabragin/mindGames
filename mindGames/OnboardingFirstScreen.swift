import SwiftUI

private enum Constants {
    static let nextButtonText: String = "Начать"
    static let onboardingDescription: String = """
            Доброго времени суток!
            
            Это приложение предназначено для тренировок памяти и внимания.
            
            Чтобы Вы могли видеть ваш прогресс, предлагаем пройти тестирование, в ходе которого мы зафиксируем Ваши начальные показатели!
            """
}

struct OnboardingFirstScreenView: View {
    
    var body: some View {
        VStack {
            Spacer()
            descriptionView
            Spacer()
            nextButton
        }
        .padding()
        .navigationTitle("Mind Games")
    }
}

// MARK: - Description View

private extension OnboardingFirstScreenView {
    var descriptionView: some View {
        Text(Constants.onboardingDescription)
            .font(.title2)
            .bold()
            .multilineTextAlignment(.center)
            .padding()
    }
}

// MARK: - Next Button

private extension OnboardingFirstScreenView {
    var nextButton: some View {
        Button(action: {
            print("LOOOL")
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
