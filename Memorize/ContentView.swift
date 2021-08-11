 //
//  ContentView.swift
//  Memorize
//
//  Created by Олег Стабровский on 08.08.2021.
//

import SwiftUI

struct ContentView: View {
	var vehicleEmojis = ["🚁", "🚗", "✈️", "🛳", "🚄",  "🛸",  "🚀",  "⛵️",
		"🚲",  "🛵",  "🛴",  "🏍",  "🚃",  "🚒",  "🚑",  "🚌",  "🚎",  "🚓",  "🚕",  "🚜", ]
	@State var emojiCount = 4
	
    var body: some View {
		VStack {
			HStack {
				ForEach(vehicleEmojis[0..<emojiCount], id: \.self) { vehicle in
					CardView(content: vehicle)
				}
			}
			Spacer(minLength: 20)
			HStack {
				remove
				Spacer()
				add
			}
			.padding(.horizontal)
			.font(.largeTitle)
		}
		.padding(.horizontal)
		.foregroundColor(.red)
    }
	
	var remove: some View {
		Button(action: {
			if emojiCount == 0 {
				return
			}
			emojiCount -= 1
		}, label: {
			Image(systemName: "minus.circle")
		})
	}
	
	var add: some View {
		Button(action: {
			if emojiCount == vehicleEmojis.count {
				return
			}
			emojiCount += 1
		}, label: {
			Image(systemName: "plus.circle")
		})
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CardView: View {
	var content: String
	@State var isFaceUp: Bool = true
	
	var body: some View {
		ZStack {
			let shape = RoundedRectangle(cornerRadius: 20)
				
			if isFaceUp {
				shape.fill().foregroundColor(.white)
				shape.stroke(lineWidth: 3)
				Text(content).font(.largeTitle)
			}
			else {
				shape.fill()
			}
		}
		.onTapGesture {
			ChangeFaceUpState()
		}
	}
	
	func ChangeFaceUpState(){
		isFaceUp = !isFaceUp
	}
}

struct FooterView: View {
	var body: some View {
		RoundedRectangle(cornerRadius: 10)
	}
}
