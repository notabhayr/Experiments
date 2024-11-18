import SwiftUI

struct BlurReplaceTextView: View {
    @State private var showFirstText = true
    
    var body: some View {
        VStack {
            ZStack {
                if showFirstText {
                    Text("Airpods")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .transition(.opacity.combined(with: .scale))
                        .blur(radius: showFirstText ? 0 : 10)
                } else {
                    Text("Mac mini")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .transition(.opacity.combined(with: .scale))
                        .blur(radius: showFirstText ? 10 : 0)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: showFirstText)
            .onTapGesture {
                showFirstText.toggle()
            }
        }
    }
}

struct BlurReplaceTextView_Previews: PreviewProvider {
    static var previews: some View {
        BlurReplaceTextView()
    }
}