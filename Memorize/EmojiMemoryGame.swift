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
	static let themeNames = [(name: "Транспорт", content: vehicleEmojis),
							 (name: "Люди", content: peopleEmojis),
							 (name: "Животные", content: animalEmojis),
							 (name: "Спорт", content: sportEmojis),
							 (name: "Еда", content: foodEmojis),
							 (name: "Флаги", content: flagEmojis),]
	
//	static func createMemoryGame() -> MemoryGame<String> {
//		MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
//			vehicleEmojis[pairIndex]
//		}
//	}
	
	static func createThemedMemoryGame(name: String, emojis: [String], cardsCount: Int, color: String) -> MemoryGame<String> {
		let theme = MemoryGame<String>.Theme(name: name, content: emojis, numberOfPairsOfCards: cardsCount, color: color)
		return MemoryGame<String>(theme: theme) {
			theme.content[$0]
		}
	}
	
	@Published private var model: MemoryGame<String> =
		createThemedMemoryGame(name: themeNames[0].name, emojis: themeNames[0].content, cardsCount: 8, color: "green")
	
	var cards: [MemoryGame<String>.Card] {
		model.cards
	}
	
	var theme: MemoryGame<String>.Theme {
		model.theme
	}
	
	var score: MemoryGame<String>.Score {
		model.score
	}
	
	
	// MARK: - Intent(s)
	
	func choose(_ card: MemoryGame<String>.Card) {
		model.choose(card)
	}
	
	func createNewRandomTheme() {
		let randomСardCount = Int.random(in: 1..<100)
		let randomThemeNumber = Int.random(in: 0..<EmojiMemoryGame.themeNames.count)
		let themeNameAndContent = EmojiMemoryGame.themeNames[randomThemeNumber]
		model =
			EmojiMemoryGame.createThemedMemoryGame(name: themeNameAndContent.name, emojis: themeNameAndContent.content, cardsCount: randomСardCount, color: "green")
	}
}
