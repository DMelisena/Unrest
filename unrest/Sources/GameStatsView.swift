import SwiftUI


// MARK: - Game Stats View
// MARK: - Game Stats View
struct GameStatsView: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        VStack(spacing: 12) {
            // Gold Coins
            HStack {
                Image(systemName: "bitcoinsign.circle.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
                Text("\(gameState.goldCoins)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.2))
            .cornerRadius(12)
            
            // Faction Stats
            HStack(spacing: 20) {
                // Left Faction
                VStack(spacing: 8) {
                    Text("LEFT")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    VStack(spacing: 4) {
                        StatBar(
                            label: "Unity",
                            value: gameState.leftUnity,
                            color: .green,
                            icon: "heart.fill"
                        )
                        
                        StatBar(
                            label: "Hate",
                            value: gameState.leftHate,
                            color: .red,
                            icon: "flame.fill"
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Divider
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 1, height: 60)
                
                // Right Faction
                VStack(spacing: 8) {
                    Text("RIGHT")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    VStack(spacing: 4) {
                        StatBar(
                            label: "Unity",
                            value: gameState.rightUnity,
                            color: .green,
                            icon: "heart.fill"
                        )
                        
                        StatBar(
                            label: "Hate",
                            value: gameState.rightHate,
                            color: .red,
                            icon: "flame.fill"
                        )
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
        }
        .padding(.horizontal)
        .background(Color.black.opacity(0.05))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}
