//
//  DragReorderView.swift
//  Experiments
//
//  Created by Abhay R on 15/11/24.
//

import SwiftUI

struct DragReorderView: View {
    // Add state properties
    @State private var cards = ["Card 1", "Card 2", "Card 3", "Card 4", "Card 5"]
    @State private var draggingItem: String?
    
    var body: some View {
        VStack {
            ForEach(cards, id: \.self) { card in
                CardView(title: card)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.vertical, 5)
                    // Add gesture modifier
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if draggingItem == nil {
                                    draggingItem = card
                                }
                            }
                            .onEnded { _ in
                                if let draggingItem = draggingItem,
                                   let from = cards.firstIndex(of: draggingItem),
                                   let to = cards.firstIndex(where: { $0 == card }) {
                                    withAnimation {
                                        self.cards.move(fromOffsets: IndexSet(integer: from),
                                                       toOffset: to > from ? to + 1 : to)
                                    }
                                }
                                self.draggingItem = nil
                            }
                    )
                    // Add scaleEffect and opacity modifiers
                    .scaleEffect(card == draggingItem ? 1.1 : 1.0)
                    .opacity(card == draggingItem ? 0.5 : 1.0)
                    .animation(.default, value: draggingItem)
            }
        }
        .padding()
    }
}

// Add CardView struct
struct CardView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
    }
}

#Preview {
    DragReorderView()
}

// End of file. No additional code.
