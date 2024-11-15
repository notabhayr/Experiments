import SwiftUI

struct ContenttView: View {
    let text = "Hello, I am newly born!"
    @State var isVisible = false
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, letter in
                Text(String(letter))
                    .font(.largeTitle.bold())
                    .offset(y: isVisible ? 0 : -10)
                    .opacity(isVisible ? 1 : 0)
                    .blur(radius: isVisible ? 0 : 5)
                    .animation(
                        .easeOut(duration: 0.3)
                        .delay(Double(index) * 0.1),
                        value: isVisible
                    )
            }
        }
        .onAppear {
            isVisible = true
        }
    }
}
struct BlurStaggerText_Previews: PreviewProvider {
    static var previews: some View {
        ContenttView()
    }
}
 
