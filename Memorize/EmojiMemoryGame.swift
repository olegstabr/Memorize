//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Олег Стабровский on 16.08.2021.
//

import SwiftUI

class EmojiMemoryGame {
	static let vehicleEmojis = ["🚁", "🚗", "✈️", "🛳", "🚄",  "🛸",  "🚀",  "⛵️",
			"🚲",  "🛵",  "🛴",  "🏍",  "🚃",  "🚒",  "🚑",  "🚌",  "🚎",
			"🚓",  "🚕",  "🚜", "🛻", "🛺", "🚇", "🛶"]
	
	static func createMemoryGame() -> MemoryGame<String> {
		MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
			vehicleEmojis[pairIndex]
		}
	}
	
	private var model: MemoryGame<String> = createMemoryGame()
	
	var cards: [MemoryGame<String>.Card] {
		model.cards
	}
}
