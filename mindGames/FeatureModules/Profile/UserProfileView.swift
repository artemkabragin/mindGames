import SwiftUI

struct UserProfileView: View {
    
    @ObservedObject var authService = AuthService.shared
    
    @State private var attentionProgress: Double = 0
    @State private var reactionProgress: Double = 0
    
    var body: some View {
        VStack {
            // Заголовок
            Text("Профиль пользователя")
                .font(.largeTitle)
                .bold()
                .padding()
            
            // Фотография пользователя (например, аватар)
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.bottom, 20)
            
            // Имя пользователя
            Text("Имя пользователя")
                .font(.title2)
                .padding(.bottom, 20)
            
            // Прогресс по играм (внимание)
            VStack(alignment: .leading) {
                Text("Прогресс по вниманию")
                    .font(.headline)
                ProgressBar(value: attentionProgress)
                Text("Текущий прогресс: \(Int(attentionProgress * 100))%")
                    .padding(.bottom, 20)
            }
            
            // Прогресс по играм (реакция)
            VStack(alignment: .leading) {
                Text("Прогресс по реакции")
                    .font(.headline)
                ProgressBar(value: reactionProgress / 100)
                Text("Текущий прогресс: \(Int(reactionProgress))%")
                    .padding(.bottom, 20)
            }
            
            logoutButton
            
        }
        .task {
            let progress = try? await GameService.shared.getProgress(by: .reaction)
            reactionProgress = progress ?? 0
        }
        .padding()
    }
    
    // Функция выхода из аккаунта
    private func logout() {
        authService.logout()
    }
}

// MARK: - Logout Button

private extension UserProfileView {
    var logoutButton: some View {
        Button(action: {
            logout()
        }) {
            Text("Выйти")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.top, 20)
    }
}

// MARK: - ProgressBar

private struct ProgressBar: View {
    var value: Double
    
    var body: some View {
        ProgressView(value: value, total: 1.0)
            .progressViewStyle(LinearProgressViewStyle())
            .accentColor(.green)
            .padding(.bottom, 10)
    }
}

#Preview {
    UserProfileView()
}
