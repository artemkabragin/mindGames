import SwiftUI

struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(card.color)
                .opacity(card.isFlipped ? 1 : 0)
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .opacity(card.isFlipped ? 0 : 1)
        }
        .frame(height: 100)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 2)
        )
        .rotation3DEffect(
            .degrees(card.isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.3), value: card.isFlipped)
    }
}

#Preview {
    CardView(
        card: Card(
            color: .red,
            isMatched: false,
            isSelected: false
        )
    )
}
