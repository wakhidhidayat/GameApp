//
//  Game.swift
//  GameApp
//
//  Created by Wahid Hidayat on 04/08/21.
//

import Foundation

struct Game: Codable {
    let id: Int
    let name: String
    let released: String
    let poster: String
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case poster = "background_image"
        case rating
    }
}

struct GameResult: Codable {
    let results: [Game]
}
