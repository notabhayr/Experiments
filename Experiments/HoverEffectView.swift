import SwiftUI

struct HoverEffectView: View {
    @State private var hoverPosition: CGFloat? = nil // Track the hover position
    let lineCount = 50 // Total number of lines
    let spacing: CGFloat = 5 // Spacing between lines
    let maxScale: CGFloat = 3.0 // Maximum scale for the hovered line
    let maxEffectRadius: CGFloat = 100 // Maximum radius of scaling effect
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: spacing) {
                ForEach(0..<lineCount, id: \.self) { index in
                    let position = CGFloat(index) * (geometry.size.width / CGFloat(lineCount)) + spacing
                    let scale = calculateScale(for: position)
                    
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 2, height: 50) // Base size of the line
                        .scaleEffect(x: 1, y: scale, anchor: .center) // Scale only vertically
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: scale)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        hoverPosition = value.location.x
                    }
                    .onEnded { _ in
                        hoverPosition = nil // Reset on gesture end
                    }
            )
            .background(Color.white)
        }
    }
    
    // Calculate the scale for each line based on the hover position
    private func calculateScale(for linePosition: CGFloat) -> CGFloat {
        guard let hoverPosition = hoverPosition else {
            return 1.0 // Default scale when not hovering
        }
        
        let distance = abs(hoverPosition - linePosition)
        if distance < maxEffectRadius {
            let normalizedDistance = 1 - (distance / maxEffectRadius)
            return 1 + (maxScale - 1) * normalizedDistance
        }
        
        return 1.0 // Default scale when out of effect radius
    }
}

#Preview {
    HoverEffectView()
}