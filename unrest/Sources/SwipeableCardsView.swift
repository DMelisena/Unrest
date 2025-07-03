import SwiftUI

struct SwipeableCardsView: View {
    @ObserveInjection var redraw
    
    class Model: ObservableObject {
        private var originalCards: [CardModel]
        @Published var unswipedCards: [CardModel]
        @Published var swipedCards: [CardModel]
        
        init(cards: [CardModel]) {
            originalCards = cards
            unswipedCards = cards
            swipedCards = []
        }
        
        func removeTopCard() {
            guard !unswipedCards.isEmpty else { return }
            let removedCard = unswipedCards.removeFirst()
            swipedCards.append(removedCard)
            
            print("Removed card: \(removedCard.title)")
            print("Remaining cards: \(unswipedCards.count)")
        }
        
        func updateTopCardSwipeDirection(_ direction: SwipeDirection) {
            guard !unswipedCards.isEmpty else { return }
            unswipedCards[0].swipeDirection = direction
        }
        
        func reset() {
            unswipedCards = originalCards.map { card in
                var resetCard = card
                resetCard.swipeDirection = .none
                return resetCard
            }
            swipedCards = []
        }
    }
    
    @StateObject var model: Model
    @State private var dragState = CGSize.zero
    @State private var isAnimating = false
    @State private var cardBeingRemoved: CardModel?
    private let swipeThreshold: CGFloat = 100.0
    private let rotationFactor: Double = 35.0
    
    var action: (Model) -> Void
    let onCardSwiped: ((CardModel, SwipeDirection) -> Void)?
    
    init(model: Model, action: @escaping (Model) -> Void, onCardSwiped: ((CardModel, SwipeDirection) -> Void)? = nil) {
        self._model = StateObject(wrappedValue: model)
        self.action = action
        self.onCardSwiped = onCardSwiped
    }
    
    var body: some View {
        GeometryReader { geometry in
            if model.unswipedCards.isEmpty && model.swipedCards.isEmpty {
                emptyCardsView
                    .frame(width: geometry.size.width, height: geometry.size.height)
            } else if model.unswipedCards.isEmpty {
                swipingCompletionView
                    .frame(width: geometry.size.width, height: geometry.size.height)
            } else {
                ZStack {
                    Color.white.ignoresSafeArea()
                    
                    // Render cards from back to front
                    ForEach(Array(model.unswipedCards.enumerated()), id: \.element.id) { index, card in
                        let isTop = index == 0
                        let isSecond = index == 1
                        let zIndex = Double(model.unswipedCards.count - index)
                        
                        CardView(
                            model: card,
                            size: geometry.size,
                            dragOffset: dragState,
                            isTopCard: isTop,
                            isSecondCard: isSecond
                        )
                        .offset(x: isTop ? dragState.width : 0)
                        .rotationEffect(.degrees(isTop ? Double(dragState.width) / rotationFactor : 0))
                        .scaleEffect(cardScale(for: index))
                        .opacity(cardOpacity(for: index))
                        .allowsHitTesting(isTop && !isAnimating)
                        .gesture(isTop ? swipeGesture : nil)
                        .zIndex(zIndex)
                        .animation(.easeInOut(duration: 0.3), value: model.unswipedCards.count)
                    }
                    
                    // Show the card being removed with exit animation
                    if let removingCard = cardBeingRemoved {
                        CardView(
                            model: removingCard,
                            size: geometry.size,
                            dragOffset: dragState,
                            isTopCard: true,
                            isSecondCard: false
                        )
                        .offset(x: dragState.width)
                        .rotationEffect(.degrees(Double(dragState.width) / rotationFactor))
                        .zIndex(1000) // Ensure it's on top during removal
                        .transition(.asymmetric(
                            insertion: .identity,
                            removal: .move(edge: dragState.width > 0 ? .trailing : .leading)
                        ))
                    }
                }
                .padding()
            }
        }
        .enableInjection()
    }
    
    private func cardScale(for index: Int) -> CGFloat {
        switch index {
        case 0: return 1.0
        case 1: return 0.95
        default: return 0.9
        }
    }
    
    private func cardOpacity(for index: Int) -> Double {
        switch index {
        case 0: return 1.0
        case 1: return 0.8
        default: return 0.6
        }
    }
    
    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                guard !isAnimating else { return }
                dragState = gesture.translation
            }
            .onEnded { _ in
                guard !isAnimating else { return }
                
                if abs(dragState.width) > swipeThreshold {
                    performSwipe()
                } else {
                    resetCard()
                }
            }
    }
    
    private func performSwipe() {
        guard let currentCard = model.unswipedCards.first else { return }
        
        let swipeDirection: SwipeDirection = dragState.width > 0 ? .right : .left
        
        print("Swiping card: \(currentCard.title), Direction: \(swipeDirection)")
        print("Cards before swipe: \(model.unswipedCards.count)")
        
        isAnimating = true
        cardBeingRemoved = currentCard
        model.updateTopCardSwipeDirection(swipeDirection)
        
        // Call the callback with the card and direction
        onCardSwiped?(currentCard, swipeDirection)
        
        // Animate the card off screen
        withAnimation(.easeOut(duration: 0.4)) {
            dragState.width = dragState.width > 0 ? 1000 : -1000
        }
        
        // Remove the card after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeInOut(duration: 0.2)) {
                model.removeTopCard()
                cardBeingRemoved = nil
            }
            
            // Reset state after a brief delay to prevent animation conflicts
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                dragState = .zero
                isAnimating = false
                
                print("Cards after swipe: \(model.unswipedCards.count)")
                if let nextCard = model.unswipedCards.first {
                    print("Next card: \(nextCard.title)")
                }
            }
        }
    }
    
    private func resetCard() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            dragState = .zero
        }
    }
    
    var emptyCardsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.stack")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Cards")
                .font(.title2)
                .foregroundColor(.gray)
        }
    }
    
    var swipingCompletionView: some View {
        VStack(spacing: 30) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("All Done!")
                .font(.title)
                .fontWeight(.semibold)
            
            Button(action: {
                action(model)
            }) {
                Text("Start Over")
                    .font(.headline)
                    .frame(width: 200, height: 50)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
