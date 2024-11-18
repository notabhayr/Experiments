import SwiftUI

struct RubberbandSquareView: View {
    @State private var isDeformed: Bool = false
    @State private var deformAmount: CGFloat = 0.0
    
    var body: some View {
        DeformableSquare(deformAmount: deformAmount)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 150, height: 150)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            .scaleEffect(isDeformed ? 1.2 : 1.0)
            .rotationEffect(isDeformed ? .degrees(5) : .degrees(0))
            .animation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5), value: isDeformed)
            .animation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5), value: deformAmount)
            .onTapGesture {
                withAnimation {
                    isDeformed = true
                    deformAmount = 15
                }
                
                // Revert after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation {
                        isDeformed = false
                        deformAmount = 0
                    }
                }
            }
    }
}

struct DeformableSquare: Shape {
    var deformAmount: CGFloat
    
    var animatableData: CGFloat {
        get { deformAmount }
        set { deformAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Define corner points with deformation
        let topLeft = CGPoint(x: rect.minX + deformAmount, y: rect.minY + deformAmount)
        let topRight = CGPoint(x: rect.maxX - deformAmount, y: rect.minY + deformAmount)
        let bottomRight = CGPoint(x: rect.maxX - deformAmount, y: rect.maxY - deformAmount)
        let bottomLeft = CGPoint(x: rect.minX + deformAmount, y: rect.maxY - deformAmount)
        
        // Create the path
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.closeSubpath()
        
        return path
    }
}

struct RubberbandSquareView_Previews: PreviewProvider {
    static var previews: some View {
        RubberbandSquareView()
    }
}