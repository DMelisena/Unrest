@_exported import HotSwiftUI
import SwiftUI

// MARK: - Updated ContentView
struct ContentView: View {
    @ObserveInjection var redraw
    @StateObject private var gameModel = GameModel()
    @StateObject private var gameState = GameState()
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingResetAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            GameStatsView(gameState: gameState)
            
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if gameModel.isLoading {
                    ProgressView("Loading Cards...")
                        .scaleEffect(1.2)
                } else if gameModel.cards.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        Text("No cards found")
                            .font(.title2)
                        Button("Retry") {
                            gameModel.loadCards()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    SwipeableCardsView(
                        model: SwipeableCardsView.Model(cards: gameModel.cards),
                        action: { model in
                            model.reset()
                        },
                        onCardSwiped: { card, direction in
                            gameState.applyCardEffects(card: card, swipeDirection: direction)
                        }
                    )
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            Button(action: {
                showingResetAlert = true
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black.opacity(0.3))
                    .clipShape(Circle())
            }
            .padding()
        }
        .onAppear {
            #if DEBUG
                Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
            #endif
            gameModel.loadCards()
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .alert("Reset Game", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                gameState.resetGame()
            }
        } message: {
            Text("Are you sure you want to reset all stats to default values?")
        }
        .onChange(of: gameModel.errorMessage) { _, newValue in
            if let error = newValue {
                errorMessage = error
                showingError = true
            }
        }
        .enableInjection()
    }
}
