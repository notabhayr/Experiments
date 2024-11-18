import SwiftUI

struct BlurSwapModifier<Content1: View, Content2: View>: ViewModifier {
    @State private var isContent1Visible: Bool = true
    @State private var isAnimating: Bool = false
    let content1: Content1
    let content2: Content2
    let animationDuration: Double

    func body(content: Content) -> some View {
        ZStack {
            if isContent1Visible {
                content1
                    .blur(radius: isAnimating ? 10 : 0)
                    .animation(.easeInOut(duration: animationDuration), value: isAnimating)
                    .transition(.opacity)
            } else {
                content2
                    .blur(radius: isAnimating ? 10 : 0)
                    .animation(.easeInOut(duration: animationDuration), value: isAnimating)
                    .transition(.opacity)
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration / 2) {
                isContent1Visible.toggle()
                isAnimating = false
            }
        }
    }
}

extension View {
    func blurSwap<Content1: View, Content2: View>(
        content1: Content1,
        content2: Content2,
        animationDuration: Double = 0.5
    ) -> some View {
        self.modifier(BlurSwapModifier(content1: content1, content2: content2, animationDuration: animationDuration))
    }
}