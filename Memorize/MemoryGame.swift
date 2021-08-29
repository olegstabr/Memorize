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
	private(set) var theme: Theme
	private(set) var score: Score
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
					score.match()
					resetSeenCards()
				}
				indexOfTheOneAndOnlyFaceUpCard = nil
			} else {
				faceDownAllCards()
				indexOfTheOneAndOnlyFaceUpCard = choosenIndex
			}
			
			if cards[choosenIndex].isSeen {
				score.penalty()
			}
			
			cards[choosenIndex].isFaceUp.toggle()
			cards[choosenIndex].isSeen = true
 		}
	}
	
	mutating func faceDownAllCards() {
		for index in cards.indices {
			cards[index].isFaceUp = false
		}
	}
	
	mutating func resetSeenCards() {
		for index in cards.indices {
			cards[index].isSeen = false
		}
	}
	
	func reduceArrayCount(receiveShowCount: inout Int, realArrayCount: Int) {
		if receiveShowCount > realArrayCount {
			receiveShowCount = realArrayCount
		}
	}
	
	func checkPairIsUsed(content: CardContent) -> Bool {
		if let _ = cards.first(where: { $0.content == content }) {
			return true
		}
		return false
	}
	
	init(theme: Theme, createCardContent: (Int) -> CardContent) {
		cards = []
		score = Score(total: 0, penaltyCost: 1, matchCost: 2)
		self.theme = theme
		
		var numberOfPairsOfCards = theme.numberOfPairsOfCards
		reduceArrayCount(receiveShowCount: &numberOfPairsOfCards, realArrayCount: theme.content.count)
		
		for pairIndex in 0..<numberOfPairsOfCards  {
			let content = createCardContent(pairIndex)
			let isPairExist = checkPairIsUsed(content: content)
			
			if !isPairExist {
				cards.append(Card(id: pairIndex * 2, content: content))
				cards.append(Card(id: pairIndex * 2 + 1, content: content))
			}
		}
		cards = cards.shuffled()
	}
	
	struct Card: Identifiable {
		var id: Int
		
		var isFaceUp: Bool = false
		var isMatched: Bool = false
		var isSeen: Bool = false
		var content: CardContent
	}
	
	struct Theme {
		var name: String
		var content: [CardContent]
		var numberOfPairsOfCards: Int
		var color: String
	}
	
	struct Score {
		var total: Int
		var penaltyCost: Int
		var matchCost: Int
		
		mutating func penalty() {
			total -= penaltyCost
		}
		
		mutating func match() {
			total += matchCost
		}
	}
}
