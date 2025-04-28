import SwiftUI

struct AchievementCell: View {
    let achievement: AchievementWithProgress
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(achievement.title)
                    .font(.headline)
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                ProgressView(value: achievement.progress)
                    .frame(width: 50)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
