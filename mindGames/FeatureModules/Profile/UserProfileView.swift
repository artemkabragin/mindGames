import SwiftUI

struct UserProfileView: View {
    
    @ObservedObject var authService = AuthService.shared
    
    @State private var attentionProgress: Double = 0
    @State private var reactionProgress: Double = 0
    
    var body: some View {
        VStack {
//            photoView
//            userNameView
            attentionProgressView
            reactionProgressView
            logoutButton
        }
        .task {
            let reactionProgressValue = try? await GameService.shared.getProgress(by: .reaction)
            reactionProgress = reactionProgressValue ?? 0
            
            let attentionProgressValue = try? await GameService.shared.getProgress(by: .cardFlip)
            attentionProgress = attentionProgressValue ?? 0
        }
        .padding()
    }
    
    private func logout() {
        authService.logout()
    }
}

// MARK: - Photo

private extension UserProfileView {
    var photoView: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .padding(.bottom, 20)
    }
}

// MARK: - Username

private extension UserProfileView {
    var userNameView: some View {
        Text("Имя пользователя")
            .font(.title2)
            .padding(.bottom, 20)
    }
}

// MARK: - Attention Progress

private extension UserProfileView {
    var attentionProgressView: some View {
        VStack(alignment: .leading) {
            Text("Прогресс по вниманию")
                .font(.headline)
            ProgressBar(value: attentionProgress / 100)
                .animation(.easeOut(duration: 1.0), value: attentionProgress)
            Text("Текущий прирост: \(Int(attentionProgress))%")
                .padding(.bottom, 20)
        }
    }
}

// MARK: - Reaction Progress

private extension UserProfileView {
    var reactionProgressView: some View {
        VStack(alignment: .leading) {
            Text("Прогресс по реакции")
                .font(.headline)
            ProgressBar(value: reactionProgress / 100)
                .animation(.easeOut(duration: 1.0), value: reactionProgress)
            Text("Текущий прирост: \(Int(reactionProgress))%")
                .padding(.bottom, 20)
        }
    }
}

// MARK: - Logout Button

private extension UserProfileView {
    var logoutButton: some View {
        Button(action: {
            logout()
        }) {
            Text("Выйти из аккаунта")
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
            .progressViewStyle(.linear)
            .accentColor(.green)
            .padding(.bottom, 10)
    }
}

#Preview {
    UserProfileView()
}
