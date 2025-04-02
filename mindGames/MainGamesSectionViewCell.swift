import SwiftUI

struct MainGamesSectionViewCellData: Hashable {
    let title: String
}

struct MainGamesSectionViewCell: View {
    
    @State var viewData: MainGamesSectionViewCellData
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.red)

            Text(viewData.title)
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
        
    }
}

#Preview {
    MainGamesSectionViewCell(viewData: .init(title: "Test"))
        .frame(width: 100, height: 100)
        .padding()
}
