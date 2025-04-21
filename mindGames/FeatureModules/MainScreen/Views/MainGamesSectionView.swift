import SwiftUI

final class MainGamesSectionViewModel: ObservableObject {
    @Published var games: [MainGamesSectionViewCellData] = [
        .init(title: "Переворот карточек"),
        .init(title: "Реакция на цвет"),
        .init(title: "Надпись с цветом")
    ]
}

struct MainGamesSectionView: View {
    
    let viewModel = MainGamesSectionViewModel()
    
    var body: some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            LazyHStack {
                ForEach(viewModel.games, id: \.self) { game in
                    MainGamesSectionViewCell(viewData: game)
                        .frame(width: 120, height: 120)
                }
            }
            .padding(.horizontal, 24)
        }
        .frame(height: 120)
    }
}

#Preview {
    MainGamesSectionView()
}
