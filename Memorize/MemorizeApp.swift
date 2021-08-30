//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Олег Стабровский on 08.08.2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
	private let game = EmojiMemoryGame()
	
    var body: some Scene {
        WindowGroup { 
            EmojiMemoryGameView(game: game)
        }
    }
}
