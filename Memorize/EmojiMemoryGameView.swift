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
						CardView(card, color: game.themeColor)
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
	private let card: EmojiMemoryGame.Card
	private var color: Color = .red
	
	init(_ card: EmojiMemoryGame.Card, color: Color) {
		self.card = card
		self.color = color
	}
	
	init(_ card: EmojiMemoryGame.Card) {
		self.card = card
	}
	
	var body: some View {
		GeometryReader(content: { geometry in
			ZStack {
				let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
					
				if card.isFaceUp {
					shape.fill().foregroundColor(.white)
					shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
					Text(card.content).font(font(in: geometry.size))
				} else if card.isMatched {
					shape.opacity(0)
				}
				else {
					shape.fill().foregroundColor(color)
				}
			}
		})
	}
	
	private func font(in size: CGSize) -> Font {
		.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
	}
	
	private struct DrawingConstants {
		static let cornerRadius: CGFloat = 20
		static let lineWidth: CGFloat = 4
		static let fontScale: CGFloat = 0.8
	}
}
