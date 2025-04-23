import SwiftUI

struct BannerView: View {
    @EnvironmentObject private var bannerService: BannerService
    @State private var showAllText: Bool = false
    let banner: BannerType
    
    let maxDragOffsetHeight: CGFloat = -50.0
    
    var body: some View {
        VStack {
            bannerContent()
        }
        .onAppear {
            guard !banner.isPersistent else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 0.2)) {
                    bannerService.removeBanner()
                }
            }
        }
        .offset(y: bannerService.dragOffset.height)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.height < 0 {
                        bannerService.dragOffset = gesture.translation
                    }
                }
                .onEnded { value in
                    if bannerService.dragOffset.height < -20 {
                        withAnimation(.easeOut(duration: 0.2)) {
                            bannerService.removeBanner()
                        }
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            bannerService.dragOffset = .zero
                        }
                    }
                }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private func bannerContent() -> some View {
        HStack(spacing: 10) {
            Image(systemName: banner.imageName)
                .padding(5)
                .background(banner.backgroundColor)
                .cornerRadius(5)
                .shadow(color: .black.opacity(0.2), radius: 3.0, x: -3, y: 4)
            
            VStack(spacing: 5) {
                Text(banner.message)
                    .foregroundColor(.black)
                    .fontWeight(.light)
                    .font(banner.message.count > 25 ? .caption : .footnote)
                    .multilineTextAlignment(.leading)
                    .lineLimit(showAllText ? nil : 2)
                
                if banner.message.count > 100 && banner.isPersistent {
                    Image(systemName: showAllText ? "chevron.compact.up" : "chevron.compact.down")
                        .foregroundColor(Color.white.opacity(0.6))
                        .fontWeight(.light)
                }
            }
            
            if banner.isPersistent {
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        bannerService.removeBanner()
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .shadow(color: .black.opacity(0.2), radius: 3.0, x: 3, y: 4)
            }
        }
        .foregroundColor(.white)
        .padding(8)
        .padding(.trailing, 2)
        .background(banner.backgroundColor)
        .cornerRadius(10)
        .shadow(radius: 3.0, x: -2, y: 2)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                self.showAllText.toggle()
            }
        }
    }
}

#Preview {
    BannerView(banner: .success(message: "Success!"))
        .environmentObject(BannerService.shared)
} 
