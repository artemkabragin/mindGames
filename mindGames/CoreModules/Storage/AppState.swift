import SwiftUI

final class AppState: ObservableObject {
        
    @AppStorage(StorageKeys.showOnboarding.rawValue) var showOnboarding: Bool = true
    
    init() {
        showOnboarding = true
    }
}

