 //
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Олег Стабровский on 08.08.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
	@ObservedObject var game: EmojiMemoryGame
	@State private var dealt = Set<Int>()
	@Namespace private var dealingNamespace
	
    var body: some View {
		ZStack(alignment: .bottom) {
			VStack {
	//			topMenu
				gameBody
//				deckBody
				HStack {
					restartButton
					Spacer()
					shuffleButton
				}
				.padding(.horizontal)
				.font(.largeTitle)
			}
			deckBody
		}
		.padding()
    }
	
	var topMenu: some View {
		VStack {
			Button(action: {
				withAnimation {
					game.createNewRandomTheme()
				}
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
	}
	
	var gameBody: some View {
		AspectVGrid(items: game.cards, aspectRatio: CardConstants.aspectRatio) { card in
			cardView(for: card)
		}
		.foregroundColor(game.themeColor)
	}
	
	var deckBody: some View {
		ZStack {
			ForEach(game.cards.filter(isUndealt)) { card in
				CardView(card)
					.matchedGeometryEffect(id: card.id, in: dealingNamespace)
					.transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
					.zIndex(zIndex(of: card))
			}
		}
		.frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
		.foregroundColor(game.themeColor)
		.onTapGesture  {
			for card in game.cards {
				withAnimation(dealAnimation(for: card)) {
					deal(card)
				}
			}
		}
	}
	
	var shuffleButton: some View {
		Button("Shuffle") {
			withAnimation {
				game.shuffle()
			}
		}
	}
	
	var restartButton: some View {
		Button("Restart") {
			withAnimation {
				dealt = []
				game.restart() 
			}
		}
	}
	
	private func zIndex (of card: EmojiMemoryGame.Card) -> Double {
		-Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
	}
	
	private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
		var delay = 0.0
		if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
			delay = Double(index) * (CardConstants.totalDealDuration /  Double(game.cards.count))
		}
		return .easeInOut(duration: CardConstants.dealDuration).delay(delay)
	}
	
	private func deal(_ card: EmojiMemoryGame.Card) {
		dealt.insert(card.id)
	}
	
	private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
		!dealt.contains(card.id)
	}
	
	@ViewBuilder
	private func cardView(for card: EmojiMemoryGame.Card) -> some View {
		if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
			Color.clear
		} else {
			CardView(card, color: game.themeColor)
				.matchedGeometryEffect(id: card.id, in: dealingNamespace)
				.padding(4)
				.transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
				.zIndex(zIndex(of: card))
				.onTapGesture {
					withAnimation {
						game.choose(card)
					}
				}
		}
	}
	
	private struct CardConstants {
		static let aspectRatio: CGFloat = 2/3
		static let dealDuration: Double = 0.3
		static let totalDealDuration: Double = 3
		static let undealtHeight: CGFloat = 90
		static let undealtWidth = undealtHeight * aspectRatio
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
	@State private var animatedBonusRemaining: Double = 0
	
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
				Group {
					if card.isConsumingBonusTime {
						Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1 - animatedBonusRemaining) * 360 - 90))
							.onAppear {
								animatedBonusRemaining = card.bonusRemaining
								withAnimation(.linear(duration: card.bonusTimeRemaining)) {
									animatedBonusRemaining = 0
								}
							}
					} else {
						Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1 - card.bonusRemaining) * 360 - 90))
					}
				}
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
