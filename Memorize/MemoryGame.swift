//
//  MemoryGame.swift
//  Memorize
//
//  Created by Олег Стабровский on 16.08.2021.
//

import Foundation

struct MemoryGame<CardContent> {
	private(set)  var cards: [Card]
	
	func choose(_card: Card) {
	}
	
	init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
		cards = []
		for pairIndex in 0..<numberOfPairsOfCards  {
			let content = createCardContent(pairIndex)
			cards.append(Card(isFaceUp: false, isMatched: false, content: content))
			cards.append(Card(isFaceUp: false, isMatched: false, content: content))
		}
	}
	
	struct Card {
		var isFaceUp: Bool
		var isMatched: Bool
		var content: CardContent
	}
}
