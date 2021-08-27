//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Олег Стабровский on 16.08.2021.
//

import SwiftUI

//ViewModel 
class EmojiMemoryGame: ObservableObject {
	static let vehicleEmojis = ["🚁", "🚗", "✈️", "🛳", "🚄",  "🛸",  "🚀",  "⛵️",
			"🚲",  "🛵",  "🛴",  "🏍",  "🚃",  "🚒",  "🚑",  "🚌",  "🚎",
			"🚓",  "🚕",  "🚜", "🛻", "🛺", "🚇", "🛶"]
	
	static func createMemoryGame() -> MemoryGame<String> {
		MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
			vehicleEmojis[pairIndex]
		}
	}
	
	@Published private var model: MemoryGame<String> = createMemoryGame()
	
	var cards: [MemoryGame<String>.Card] {
		model.cards
	}
	
	// MARK: - Intent(s)
	
	func choose(_ card: MemoryGame<String>.Card) {
		model.choose(card)
	}
}
