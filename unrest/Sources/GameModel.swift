import SwiftUI

// MARK: - Card Data Models
struct CardJSONData: Codable {
    let id: String
    let title: String
    let analogueFor: String
    let description: String
    let effects: CardEffects
    let coinValue: Int
    let explanation: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, effects, explanation
        case analogueFor = "analogue_for"
        case coinValue = "coin_value"
    }
}

struct CardEffects: Codable {
    let givenFaction: FactionEffect
    let oppositeFaction: FactionEffect
    
    enum CodingKeys: String, CodingKey {
        case givenFaction = "given_faction"
        case oppositeFaction = "opposite_faction"
    }
}

struct FactionEffect: Codable {
    let hateChange: Int
    let unityChange: Int
    
    enum CodingKeys: String, CodingKey {
        case hateChange = "hate_change"
        case unityChange = "unity_change"
    }
}

// MARK: - Card Model for SwipeableCardsView
struct CardModel: Identifiable, Codable {
    let id: String
    let title: String
    let analogueFor: String
    let description: String
    let effects: CardEffects
    let coinValue: Int
    let explanation: String
    var swipeDirection: SwipeDirection = .none
    
    init(id: String = UUID().uuidString, title: String, analogueFor: String, description: String, effects: CardEffects, coinValue: Int, explanation: String) {
        self.id = id
        self.title = title
        self.analogueFor = analogueFor
        self.description = description
        self.effects = effects
        self.coinValue = coinValue
        self.explanation = explanation
    }
}

enum SwipeDirection: String, Codable {
    case left, right, none
}

// MARK: - GameModel
class GameModel: ObservableObject {
    @Published var cards: [CardModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadCards() {
        isLoading = true
        errorMessage = nil
        
        guard let url = Bundle.main.url(forResource: "cards", withExtension: "json") else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Could not find cards.json file in bundle"
            }
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonCards = try decoder.decode([CardJSONData].self, from: data)
            
            let loadedCards = jsonCards.map { jsonCard in
                CardModel(
                    id: jsonCard.id,
                    title: jsonCard.title,
                    analogueFor: jsonCard.analogueFor,
                    description: jsonCard.description,
                    effects: jsonCard.effects,
                    coinValue: jsonCard.coinValue,
                    explanation: jsonCard.explanation
                )
            }
            
            DispatchQueue.main.async {
                self.cards = loadedCards
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Failed to load cards: \(error.localizedDescription)"
            }
        }
    }
}
