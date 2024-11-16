import SwiftUI

// Main View
struct LineByLineStaggeredView: View {
    let text: String // This is the full text we want to display line by line
    @State private var visibleLines: Set<Int> = [] // Keeps track of which lines are currently visible (shown on screen)

    var body: some View {
        // ScrollView lets the user scroll through the text
        ScrollView {
            // VStack arranges all the lines vertically, with some spacing between them
            VStack(alignment: .leading, spacing: 12) {
                // Split the text into individual lines
                let lines = splitTextIntoLines(text: text)
                
                // Loop through each line using its index
                ForEach(lines.indices, id: \.self) { lineIndex in
                    // Show the current line of text
                    Text(lines[lineIndex])
                        .font(.system(size: 20)) // Set the font size
                        .multilineTextAlignment(.leading) // Align text to the left
                        .blur(radius: visibleLines.contains(lineIndex) ? 0 : 4) // Blur if the line is not yet visible
                        .opacity(visibleLines.contains(lineIndex) ? 1 : 0) // Make it fade in when visible
                        .offset(x: visibleLines.contains(lineIndex) ? 0 : 10) // Slide in from the right when visible
                        .animation(
                            .easeOut(duration: 0.5), // Smoothly animate the change
                            value: visibleLines.contains(lineIndex) // Trigger the animation when the visibility changes
                        )
                        // Use a GeometryReader to know where this line is on the screen
                        .background(
                            GeometryReader { geometry in
                                Color.clear // Add an invisible background
                                    // When the line appears or its position changes, check if it's visible
                                    .onAppear {
                                        updateVisibility(geometry: geometry, index: lineIndex)
                                    }
                                    .onChange(of: geometry.frame(in: .global)) { _ in
                                        updateVisibility(geometry: geometry, index: lineIndex)
                                    }
                            }
                        )
                }
            }
            .padding() // Add some space around the text
        }
    }

    // This function checks if a line is visible on the screen
    private func updateVisibility(geometry: GeometryProxy, index: Int) {
        let frame = geometry.frame(in: .global) // Get the position of the line on the screen
        let screenHeight = UIScreen.main.bounds.height // Get the height of the screen

        // If any part of the line is on the screen
        if frame.minY < screenHeight && frame.maxY > 0 {
            DispatchQueue.main.async {
                visibleLines.insert(index) // Mark the line as visible
            }
        } else {
            // If the line is off the screen
            DispatchQueue.main.async {
                visibleLines.remove(index) // Mark the line as not visible
            }
        }
    }

    // This function splits the long paragraph into lines that fit within the screen width
    private func splitTextIntoLines(text: String) -> [String] {
        let font = UIFont.systemFont(ofSize: 20) // Use the same font as the Text view
        let textWidth = UIScreen.main.bounds.width - 40 // Screen width minus padding
        let attributedText = NSAttributedString(string: text, attributes: [.font: font]) // Add font attributes to the text
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText) // Use Core Text to calculate line breaks
        let path = CGPath(rect: CGRect(x: 0, y: 0, width: textWidth, height: .greatestFiniteMagnitude), transform: nil) // Create a "box" where the text fits
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: attributedText.length), path, nil) // Create lines within the box

        let lines = CTFrameGetLines(frame) as! [CTLine] // Extract the individual lines
        var result: [String] = []

        // Loop through each line and extract the text
        for line in lines {
            let range = CTLineGetStringRange(line) // Get the range of characters in the line
            let startIndex = text.index(text.startIndex, offsetBy: range.location) // Find the starting position
            let endIndex = text.index(startIndex, offsetBy: range.length) // Find the ending position
            result.append(String(text[startIndex..<endIndex])) // Add the line to the result
        }

        return result // Return the list of lines
    }
}

struct LineByLineStaggeredView_Previews: PreviewProvider {
    static var previews: some View {
        // This adds a ScrollView so you can preview the animation with scrolling
        ScrollView {
            VStack {
                // Add some space at the top
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 400)
                    .cornerRadius(20)
                    .padding(20)
                // The main view to display the animated lines
                LineByLineStaggeredView(text: """
                SwiftUI is a great library and easy to use. It allows developers to build user interfaces for all Apple platforms using a declarative Swift syntax. This approach enables flexible and powerful interface designs while reducing boilerplate code. SwiftUI is a great library and easy to use. It allows developers to build user interfaces for all Apple platforms using a declarative Swift syntax. 
                SwiftUI is a great library and easy to use. It allows developers to build user interfaces for all Apple platforms using a declarative Swift syntax. This approach enables flexible and powerful interface designs while reducing boilerplate code. SwiftUI is a great library and easy to use. It allows developers to build user interfaces for all Apple platforms using a declarative Swift syntax. 
                SwiftUI is a great library and easy to use. It allows developers to build user interfaces for all Apple platforms using a declarative Swift syntax. This approach enables flexible and powerful interface designs while reducing boilerplate code. SwiftUI is a great library and easy to use. It allows developers to build user interfaces for all Apple platforms using a declarative Swift syntax. 
                """)
            }
        }
    }
}
