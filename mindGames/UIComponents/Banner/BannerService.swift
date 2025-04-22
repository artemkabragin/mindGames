import Foundation
import SwiftUI

class BannerService: ObservableObject {
    
    static let shared = BannerService()
    
    private init() {}
    
    // MARK: - Public Properties
    
    @Published var isAnimating = false
    @Published var dragOffset = CGSize.zero
    @Published var bannerType: BannerType? {
        didSet {
            if bannerType != nil {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isAnimating = true
                }
            } else {
                withAnimation(.easeOut(duration: 0.2)) {
                    isAnimating = false
                }
            }
        }
    }
    
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
            self.isAnimating = false
            self.dragOffset = .zero
        }
    }
} 
