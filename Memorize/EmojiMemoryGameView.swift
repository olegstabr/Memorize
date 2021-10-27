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
			AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
				cardView(for: card)
			}
			.foregroundColor(game.themeColor)
		}
		.padding(.horizontal)
		.font(.largeTitle)
    }
	
	@ViewBuilder
	private func cardView(for card: EmojiMemoryGame.Card) -> some View {
		if card.isMatched && !card.isFaceUp {
			Rectangle().opacity(0)
		} else {
			CardView(card, color: game.themeColor)
				.padding(4)
				.onTapGesture {
					game.choose(card)
				}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		let game = EmojiMemoryGame()
		game.choose(game.cards.first!)
		return EmojiMemoryGameView(game: game)
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
				Pie(startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 110))
					.padding(DrawingConstants.insideCardCirclePadding)
					.opacity(DrawingConstants.insideCardCircleOpacity)
				Text(card.content)
					.rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
					.animation(.linear(duration: 1).repeatForever(autoreverses: false))
					.font(.system(size: DrawingConstants.fonSize))
					.scaleEffect(scale(thatFits: geometry.size))
			}
			.cardify(isFaceUp: card.isFaceUp)
		})
	}
	
	private func scale(thatFits scale: CGSize) -> CGFloat {
		min(scale.width, scale.height) / (DrawingConstants.fonSize / DrawingConstants.fontScale)
	}
	
	private struct DrawingConstants {
		static let fontScale: CGFloat = 0.6
		static let fonSize: CGFloat = 32
		static let insideCardCirclePadding: CGFloat = 5
		static let insideCardCircleOpacity: Double = 0.5
	}
}
