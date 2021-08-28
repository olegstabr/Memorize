//
//  MemoryGame.swift
//  Memorize
//
//  Created by Олег Стабровский on 16.08.2021.
//

import Foundation

// Model
struct MemoryGame<CardContent> where CardContent: Equatable{
	private(set) var cards: [Card]
	private var indexOfTheOneAndOnlyFaceUpCard: Int?
	
	mutating func choose(_ card: Card) {
		if let choosenIndex = cards.firstIndex(where: { $0.id == card.id }),
		   !cards[choosenIndex].isFaceUp,
		   !cards[choosenIndex].isMatched
		{
			if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
				if cards[choosenIndex].content == cards[potentialMatchIndex].content {
					cards[choosenIndex].isMatched = true
					cards[potentialMatchIndex].isMatched = true
				}
				indexOfTheOneAndOnlyFaceUpCard = nil
			} else {
				faceDownAllCards()
				indexOfTheOneAndOnlyFaceUpCard = choosenIndex
			}
			
			cards[choosenIndex].isFaceUp.toggle()
 		}
	}
	
	mutating func faceDownAllCards() {
		for index in cards.indices {
			cards[index].isFaceUp = false
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
		
		var isFaceUp: Bool = false
		var isMatched: Bool = false
		var content: CardContent
	}
	
	struct Theme {
		var name: String
		var emojis: [String]
		var numberOfPairsOfCards: Int
		var color: String
	}
}
