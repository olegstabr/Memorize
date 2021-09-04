//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Олег Стабровский on 16.08.2021.
//

import SwiftUI

//ViewModel 
class EmojiMemoryGame: ObservableObject {
	typealias Card = MemoryGame<String>.Card
	typealias Theme = MemoryGame<String>.Theme
	typealias Score = MemoryGame<String>.Score
	
	private static let vehicleEmojis = ["🚁", "🚗", "✈️", "🛳", "🚄",  "🛸",  "🚀",  "⛵️",
			"🚲",  "🛵",  "🛴",  "🏍",  "🚃",  "🚒",  "🚑",  "🚌",  "🚎",
			"🚓",  "🚕",  "🚜", "🛻", "🛺", "🚇", "🛶"]
	private static let peopleEmojis = ["👶", "👩", "👨🏽‍🦰", "🧔‍♀️", "👨‍🦳", "👮", "🕵️‍♀️", "👩‍🌾", "💂‍♀️",
						"👨‍⚕️", "👨‍🎓", "👩‍🏫", "👨‍💻", "👩‍🚒", "🧑‍🚀", "🧑‍⚖️", "🧙", "🧛‍♀️"]
	private static let animalEmojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️",
						"🐨", "🐸", "🐤", "🦅"]
	private static let sportEmojis = ["⚽️", "🏀", "⚾️", "🏈", "🥎", "🎾", "🏐", "🏉", "🥏",
					   "🏒", "🏏", "🥋", "🤼‍♂️", "🏋️‍♀️", "🎿", "🏄‍♂️", "🏄", "🏊‍♂️"]
	private static let foodEmojis = ["🍏", "🍎", "🍐", "🍊", "🍋", "🍓", "🫐", "🍑", "🥝",
					  "🍍", "🥦", "🫑", "🍔", "🌭", "🌯"]
	private static let flagEmojis = ["🏴‍☠️", "🇦🇺", "🏳️‍🌈", "🏳️‍⚧️", "🇦🇷", "🏴󠁧󠁢󠁷󠁬󠁳󠁿", "🇻🇮", "🇬🇦", "🇹🇱",
					  "🇯🇪", "🇨🇦", "🇰🇬", "🇷🇺", "🇲🇰", "🇸🇲"]
	private static let themesInfo = [(name: "Транспорт", content: vehicleEmojis, color: "yellow"),
							 (name: "Люди", content: peopleEmojis, color: "green"),
							 (name: "Животные", content: animalEmojis, color: "yellow"),
							 (name: "Спорт", content: sportEmojis, color: "pink"),
							 (name: "Еда", content: foodEmojis, color: "purple"),
							 (name: "Флаги", content: flagEmojis, color: "blue")]
	
//	static func createMemoryGame() -> MemoryGame<String> {
//		MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
//			vehicleEmojis[pairIndex]
//		}
//	}
	
	private static func createThemedMemoryGame(name: String, emojis: [String], cardsCount: Int, color: String) -> MemoryGame<String> {
		let theme = MemoryGame<String>.Theme(name: name, content: emojis, numberOfPairsOfCards: cardsCount, color: color)
		return MemoryGame<String>(theme: theme) {
			theme.content[$0]
		}
	}
	
	@Published private var model: MemoryGame<String> =
		createThemedMemoryGame(name: themesInfo[0].name, emojis: themesInfo[0].content, cardsCount: 8, color: "red")
	
	var cards: [Card] {
		model.cards
	}
	
	var theme: Theme {
		model.theme
	}
	
	var score: Score {
		model.score
	}
	
	var themeColor: Color {
		switch model.theme.color {
		case "red":
			return .red
		case "green":
			return .green
		case "yellow":
			return .yellow
		case "pink":
			return .pink
		case "purple":
			return .purple
		case "blue":
			return .blue
		case "orange":
			return .orange
		default:
			return .red
		}
	}
	
	
	// MARK: - Intent(s)
	
	func choose(_ card: Card) {
		model.choose(card)
	}
	
	func createNewRandomTheme() {
		let randomСardCount = Int.random(in: 1..<35)
		let randomThemeNumber = Int.random(in: 0..<EmojiMemoryGame.themesInfo.count)
		let themeInfo = EmojiMemoryGame.themesInfo[randomThemeNumber]
		model =
			EmojiMemoryGame.createThemedMemoryGame(name: themeInfo.name, emojis: themeInfo.content, cardsCount: randomСardCount, color: themeInfo.color)
	}
}
