//
//  MemoryGame.swift
//  Memorize
//
//  Created by Олег Стабровский on 16.08.2021.
//

import Foundation

// Model
struct MemoryGame<CardContent> where CardContent: Equatable {
	private(set) var cards: [Card]
	private(set) var theme: Theme
	private(set) var score: Score
	
	private var indexOfTheOneAndOnlyFaceUpCard: Int? {
		get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
		set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
	}
	
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
				cards[choosenIndex].isFaceUp = true
			} else {
				indexOfTheOneAndOnlyFaceUpCard = choosenIndex
			}
			
			if cards[choosenIndex].isSeen {
				score.penalty()
			}
			
			cards[choosenIndex].isSeen = true
 		}
	}
	
	mutating func shuffle() {
		cards.shuffle()
	}
	
	private mutating func resetSeenCards() {
		cards.indices.forEach({ cards[$0].isSeen = false })
	}
	
	private func reduceArrayCount(receiveShowCount: inout Int, realArrayCount: Int) {
		if receiveShowCount > realArrayCount {
			receiveShowCount = realArrayCount
		}
	}
	
	private func checkPairIsUsed(content: CardContent) -> Bool {
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
		shuffle()
	}
	
	struct Card: Identifiable {
		var id: Int
		
		var isFaceUp = false
		var isMatched = false
		var isSeen = false
		var content: CardContent
	}
	
	struct Theme {
		var name: String
		var content: [CardContent]
		var numberOfPairsOfCards: Int
		var color: String
		
		init(name: String, content: [CardContent], numberOfPairsOfCards: Int, color: String) {
			self.name = name
			self.content = content
			self.numberOfPairsOfCards = numberOfPairsOfCards
			self.color = color
		}
		
		init(name: String, content: [CardContent], color: String) {
			self.name = name
			self.content = content
			self.color = color
			self.numberOfPairsOfCards = self.content.count
		}
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

extension Array {
	var oneAndOnly: Element? {
		return count == 1 ? first : nil
	}
}
