import Foundation
import SwiftUI

final class BannerService: ObservableObject {
    
    static let shared = BannerService()
    
    private init() {}
    
    // MARK: - Public Properties
    
    @Published var dragOffset = CGSize.zero
    @Published private(set) var bannerType: BannerType?
    
    // MARK: - Public Methods
    
    func setBanner(_ banner: BannerType) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            self.bannerType = banner
        }
    }
    
    @MainActor
    func removeBanner() {
        withAnimation(.easeOut(duration: 0.2)) {
            self.bannerType = nil
            self.dragOffset = .zero
        }
    }
}
