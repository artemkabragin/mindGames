import SwiftUI

struct ColorAnswer: Identifiable {
    let id = UUID()
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    init(color: Color) {
        self.name = color.getName()
    }
}
