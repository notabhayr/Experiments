import SwiftUI

struct TabsView: View {
    @State private var activeTab: Int = 0
    @State private var pillPosition: CGFloat = 0
    @State private var pillWidth: CGFloat = 0
    @State private var isDarkMode: Bool = true
    
    let tabs = ["All Posts", "Engineering", "Community", "Press", "Changelog"]
    
    var body: some View {
        ZStack {
            // Background
            (isDarkMode ? Color.black : Color.white)
                .ignoresSafeArea()
                .animation(.easeInOut, value: isDarkMode)
            
            VStack {
                // Theme Toggle
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isDarkMode.toggle()
                        }
                    }) {
                        Text(isDarkMode ? "🌙" : "☀️")
                            .font(.largeTitle)
                    }
                    .padding()
                }
                
                Spacer()
                
                // Tabs
                ZStack {
                    // Background Pill
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isDarkMode ? Color.white : Color.black)
                        .frame(width: pillWidth, height: 40)
                        .position(x: pillPosition, y: 20)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5), value: pillPosition)
                    
                    // Tabs
                    HStack(spacing: 20) {
                        ForEach(tabs.indices, id: \.self) { index in
                            Text(tabs[index])
                                .fontWeight(.medium)
                                .foregroundColor(index == activeTab ? (isDarkMode ? Color.black : Color.white) : (isDarkMode ? Color.white : Color.black))
                                .padding(.horizontal, 12)
                                .onTapGesture {
                                    activeTab = index
                                }
                                .background(
                                    GeometryReader { geometry in
                                        Color.clear
                                            .onAppear {
                                                if index == activeTab {
                                                    updatePillPosition(geometry: geometry)
                                                }
                                            }
                                            .onChange(of: activeTab) { newValue in
                                                if index == newValue {
                                                    updatePillPosition(geometry: geometry)
                                                }
                                            }
                                    }
                                )
                                .frame(height: 40)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(isDarkMode ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                )
                .padding()
                
                Spacer()
            }
        }
    }
    
    // Updates the pill's position and size based on the active tab
    private func updatePillPosition(geometry: GeometryProxy) {
        DispatchQueue.main.async {
            let width = geometry.size.width
            let midX = geometry.frame(in: .global).midX
            pillWidth = width + 24 // Adding extra margin
            pillPosition = midX
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}