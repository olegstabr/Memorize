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
	static let peopleEmojis = ["👶", "👩", "👨🏽‍🦰", "🧔‍♀️", "👨‍🦳", "👮", "🕵️‍♀️", "👩‍🌾", "💂‍♀️",
						"👨‍⚕️", "👨‍🎓", "👩‍🏫", "👨‍💻", "👩‍🚒", "🧑‍🚀", "🧑‍⚖️", "🧙", "🧛‍♀️"]
	static let animalEmojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️",
						"🐨", "🐸", "🐤", "🦅"]
	static let sportEmojis = ["⚽️", "🏀", "⚾️", "🏈", "🥎", "🎾", "🏐", "🏉", "🥏",
					   "🏒", "🏏", "🥋", "🤼‍♂️", "🏋️‍♀️", "🎿", "🏄‍♂️", "🏄", "🏊‍♂️"]
	static let foodEmojis = ["🍏", "🍎", "🍐", "🍊", "🍋", "🍓", "🫐", "🍑", "🥝",
					  "🍍", "🥦", "🫑", "🍔", "🌭", "🌯"]
	static let flagEmojis = ["🏴‍☠️", "🇦🇺", "🏳️‍🌈", "🏳️‍⚧️", "🇦🇷", "🏴󠁧󠁢󠁷󠁬󠁳󠁿", "🇻🇮", "🇬🇦", "🇹🇱",
					  "🇯🇪", "🇨🇦", "🇰🇬", "🇷🇺", "🇲🇰", "🇸🇲"]
	
//	static func createMemoryGame() -> MemoryGame<String> {
//		MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
//			vehicleEmojis[pairIndex]
//		}
//	}
	
	static func createThemedMemoryGame(name: String, emojis: [String], cardsCount: Int, color: String) -> MemoryGame<String> {
		let theme = MemoryGame<String>.Theme(name: name, content: emojis, numberOfPairsOfCards: cardsCount, color: color)
		return MemoryGame<String>(numberOfPairsOfCards: cardsCount, theme: theme) {
			theme.content[$0]
		}
	}
	
	@Published private var model: MemoryGame<String> =
		createThemedMemoryGame(name: "Спорт", emojis: sportEmojis, cardsCount: 8, color: "green")
	
	var cards: [MemoryGame<String>.Card] {
		model.cards
	}
	
	
	// MARK: - Intent(s)
	
	func choose(_ card: MemoryGame<String>.Card) {
		model.choose(card)
	}
	
	func createNewRandomTheme() {
		model =
			EmojiMemoryGame.createThemedMemoryGame(name: "Спорт", emojis: EmojiMemoryGame.sportEmojis, cardsCount: 8, color: "green")
	}
}
