 //
//  ContentView.swift
//  Memorize
//
//  Created by Олег Стабровский on 08.08.2021.
//

import SwiftUI

struct ContentView: View {
	var vehicleEmojis = ["🚁", "🚗", "✈️", "🛳", "🚄",  "🛸",  "🚀",  "⛵️",
		"🚲",  "🛵",  "🛴",  "🏍",  "🚃",  "🚒",  "🚑",  "🚌",  "🚎",  "🚓",  "🚕",  "🚜", "🛻", "🛺", "🚇", "🛶"]
	var peopleEmojis = ["👶", "👩", "👨🏽‍🦰", "🧔‍♀️", "👨‍🦳", "👮", "🕵️‍♀️", "👩‍🌾", "💂‍♀️", "👨‍⚕️", "👨‍🎓", "👩‍🏫", "👨‍💻", "👩‍🚒", "🧑‍🚀", "🧑‍⚖️", "🧙", "🧛‍♀️"]
	var animalEmojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐸", "🐤", "🦅"]
	@State var usedEmojis = ["🚁", "🚗", "✈️", "🛳", "🚄",  "🛸",  "🚀",  "⛵️",
							 "🚲",  "🛵",  "🛴",  "🏍",  "🚃",  "🚒",  "🚑",  "🚌",  "🚎",  "🚓",  "🚕",  "🚜", "🛻", "🛺", "🚇", "🛶"]
	@State var emojiCount = 14
	
    var body: some View {
		VStack {
			Text("Memorize!").font(.largeTitle)
			ScrollView {
				LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
					ForEach(usedEmojis[0..<emojiCount], id: \.self) { emoji in
						CardView(content: emoji).aspectRatio(2/3, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
					}
				}
			}
			.foregroundColor(.red)
			Spacer(minLength: 20)
			HStack {
				CreateThemeButton(themeName: "Vehicles")
				Spacer()
				CreateThemeButton(themeName: "People")
				Spacer()
				CreateThemeButton(themeName: "Animals")
			}
			.padding(.horizontal)
			.font(.largeTitle)
		}
		.padding(.horizontal)
    }
	
	func CreateThemeButton(themeName: String) -> some View {
		var imageSystemName: String
		var needShowTypeEmojis: [String]
		
		switch themeName {
		case "Animals":
			imageSystemName = "hare"
			needShowTypeEmojis = animalEmojis
		case "People":
			imageSystemName = "person"
			needShowTypeEmojis = peopleEmojis
		case "Vehicles":
			imageSystemName = "car"
			needShowTypeEmojis = vehicleEmojis
		default:
			imageSystemName = "questionmark.circle"
			needShowTypeEmojis = animalEmojis
		}
		
		return Button(action: {
			usedEmojis = needShowTypeEmojis
			usedEmojis.shuffle()
			emojiCount = Int.random(in: 0..<usedEmojis.count)
		}, label: {
			VStack {
				Image(systemName: imageSystemName)
				Text(themeName).font(.title2)
			}
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
				shape.strokeBorder(lineWidth: 4)
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
