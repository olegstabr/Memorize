 //
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Олег Стабровский on 08.08.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
	@ObservedObject var game: EmojiMemoryGame
	
    var body: some View {
		VStack {
			VStack {
				Button(action: {
					game.createNewRandomTheme()
				}, label: {
					HStack {
						Spacer()
						Image(systemName: "plus")
					}
					.font(.largeTitle)
				})
				HStack {
					Text("Тема: \(game.theme.name)")
					Spacer()
				}
				HStack {
					Text("Счет: \(game.score.total)")
					Spacer()
				}
			}
			.foregroundColor(game.themeColor)
			.padding(.horizontal)
			ScrollView {
				LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
					ForEach(game.cards) { card in
						CardView(card: card, color: game.themeColor)
							.aspectRatio(2/3, contentMode: .fit)
							.onTapGesture {
								game.choose(card)
							}
					}
				}
			}
			.foregroundColor(game.themeColor)
		}
		.padding(.horizontal)
		.font(.largeTitle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		let game = EmojiMemoryGame()
		EmojiMemoryGameView(game: game)
    }
}

struct CardView: View {
	let card: MemoryGame<String>.Card
	var color: Color = .red
	
	init(card: MemoryGame<String>.Card, color: Color) {
		self.card = card
		self.color = color
	}
	
	init(card: MemoryGame<String>.Card) {
		self.card = card
	}
	
	var body: some View {
		ZStack {
			let shape = RoundedRectangle(cornerRadius: 20)
				
			if card.isFaceUp {
				shape.fill().foregroundColor(.white)
				shape.strokeBorder(lineWidth: 4)
				Text(card.content).font(.largeTitle)
			} else if card.isMatched {
				shape.opacity(0)
			}
			else {
				shape.fill().foregroundColor(color)
			}
		}
	}
}
