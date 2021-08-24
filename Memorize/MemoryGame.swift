//
//  MemoryGame.swift
//  Memorize
//
//  Created by Олег Стабровский on 16.08.2021.
//

import Foundation

struct MemoryGame<CardContent> {
	private(set) var cards: [Card]
	
	mutating func choose(_ card: Card) {
		if let index = cards.firstIndex(where: { $0.id == card.id }) {
			cards[index].isFaceUp.toggle()
			print("\(cards)")
		}
	}
	
	init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
		cards = []
		for pairIndex in 0..<numberOfPairsOfCards  {
			let content = createCardContent(pairIndex)
			cards.append(Card(id: pairIndex * 2, content: content))
			cards.append(Card(id: pairIndex * 2 + 1, content: content))
		}
	}
	
	struct Card: Identifiable {
		var id: Int
		
		var isFaceUp: Bool = true
		var isMatched: Bool = false
		var content: CardContent
	}
}
