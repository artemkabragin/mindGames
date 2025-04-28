import SwiftUI

struct GameCell: View {
    let gameType: GameType
    
    var body: some View {
        VStack {
            Image(systemName: gameType.imageName)
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .frame(width: 80, height: 80)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Text(gameType.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(gameType.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 200)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}
