//
//  GameState.swift
//  unrest
//
//  Created by Arya Hanif on 29/06/25.
//
import SwiftUI

// MARK: - Game State Model
class GameState: ObservableObject {
    @Published var leftUnity: Int = 10
    @Published var leftHate: Int = 10
    @Published var rightUnity: Int = 10
    @Published var rightHate: Int = 10
    @Published var goldCoins: Int = 0
    
    // Save to UserDefaults
    private let defaults = UserDefaults.standard
    
    init() {
        loadGameState()
    }
    
    func saveGameState() {
        defaults.set(leftUnity, forKey: "leftUnity")
        defaults.set(leftHate, forKey: "leftHate")
        defaults.set(rightUnity, forKey: "rightUnity")
        defaults.set(rightHate, forKey: "rightHate")
        defaults.set(goldCoins, forKey: "goldCoins")
    }
    
    func loadGameState() {
        leftUnity = defaults.object(forKey: "leftUnity") as? Int ?? 10
        leftHate = defaults.object(forKey: "leftHate") as? Int ?? 10
        rightUnity = defaults.object(forKey: "rightUnity") as? Int ?? 10
        rightHate = defaults.object(forKey: "rightHate") as? Int ?? 10
        goldCoins = defaults.object(forKey: "goldCoins") as? Int ?? 0
    }
    
    func applyCardEffects(card: CardModel, swipeDirection: SwipeDirection) {
        guard swipeDirection != .none else { return }
        
        let effects = card.effects
        
        if swipeDirection == .left {
            // Apply effects to left faction (given faction)
            leftUnity = max(0, min(20, leftUnity + effects.givenFaction.unityChange))
            leftHate = max(0, min(20, leftHate + effects.givenFaction.hateChange))
            
            // Apply effects to right faction (opposite faction)
            rightUnity = max(0, min(20, rightUnity + effects.oppositeFaction.unityChange))
            rightHate = max(0, min(20, rightHate + effects.oppositeFaction.hateChange))
        } else if swipeDirection == .right {
            // Apply effects to right faction (given faction)
            rightUnity = max(0, min(20, rightUnity + effects.givenFaction.unityChange))
            rightHate = max(0, min(20, rightHate + effects.givenFaction.hateChange))
            
            // Apply effects to left faction (opposite faction)
            leftUnity = max(0, min(20, leftUnity + effects.oppositeFaction.unityChange))
            leftHate = max(0, min(20, leftHate + effects.oppositeFaction.hateChange))
        }
        
        // Add coin value
        goldCoins += card.coinValue
        
        // Save the updated state
        saveGameState()
    }
    
    func resetGame() {
        leftUnity = 10
        leftHate = 10
        rightUnity = 10
        rightHate = 10
        goldCoins = 0
        saveGameState()
    }
}
