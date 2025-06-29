@_exported import HotSwiftUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            let cards = [
                CardView.Model(text: "Card 1"),
                CardView.Model(text: "Card 2"),
                CardView.Model(text: "Card 3"),
                CardView.Model(text: "Card 4"),
            ]

            let model = SwipeableCardsView.Model(cards: cards)
            SwipeableCardsView(model: model) { model in
                print(model.swipedCards)
                model.reset()
            }
        }
        .onAppear {
            #if DEBUG
                Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
            #endif
        }
        .enableInjection() // Xcode16 default support: SWIFT_ENABLE_OPAQUE_TYPE_ERASURE
    }

    @ObserveInjection var redraw
}

#Preview {
    ContentView()
}
