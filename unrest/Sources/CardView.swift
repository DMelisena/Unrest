import SwiftUI
struct CardView: View {
    @ObserveInjection var redraw
    
    var model: CardModel
    var size: CGSize
    var dragOffset: CGSize
    var isTopCard: Bool
    var isSecondCard: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text(model.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(model.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            // Effects display
            VStack(spacing: 12) {
                HStack {
                    Text("Coin Value:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(model.coinValue)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                
                VStack(spacing: 8) {
                    effectRow(title: "Given Faction", effect: model.effects.givenFaction)
                    effectRow(title: "Opposite Faction", effect: model.effects.oppositeFaction)
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .frame(width: size.width * 0.85, height: size.height * 0.7)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(
                    color: isTopCard ? getShadowColor() :
                           (isSecondCard ? Color.black.opacity(0.1) : Color.clear),
                    radius: isTopCard ? 15 : 8,
                    x: 0,
                    y: isTopCard ? 5 : 3
                )
        )
        .overlay(
            // Swipe direction indicators
            Group {
                if isTopCard && abs(dragOffset.width) > 50 {
                    VStack {
                        HStack {
                            if dragOffset.width > 0 {
                                rightSwipeIndicator
                                Spacer()
                            } else {
                                Spacer()
                                leftSwipeIndicator
                            }
                        }
                        Spacer()
                    }
                    .padding(30)
                }
            }
        )
        .enableInjection()
    }

    private func getShadowColor() -> Color {
        if dragOffset.width > 50 {
            return Color.red.opacity(0.7)
        } else if dragOffset.width < -50 {
            return Color.blue.opacity(0.7)
        } else {
            return Color.black.opacity(0.1)
        }
    }
    
    private var leftSwipeIndicator: some View {
        Text("BLUE")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.blue)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 3)
            )
            .rotationEffect(.degrees(-15))
    }
    
    private var rightSwipeIndicator: some View {
        Text("RED")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.red)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: 3)
            )
            .rotationEffect(.degrees(15))
    }
    
    private func effectRow(title: String, effect: FactionEffect) -> some View {
        HStack {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            Spacer()
            HStack(spacing: 8) {
                Label("\(effect.hateChange > 0 ? "+" : "")\(effect.hateChange)", systemImage: "flame.fill")
                    .font(.caption2)
                    .foregroundColor(effect.hateChange > 0 ? .red : (effect.hateChange < 0 ? .blue : .secondary))
                Label("\(effect.unityChange > 0 ? "+" : "")\(effect.unityChange)", systemImage: "link")
                    .font(.caption2)
                    .foregroundColor(effect.unityChange > 0 ? .blue : (effect.unityChange < 0 ? .orange : .secondary))
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
