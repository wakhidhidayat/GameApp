//
//  DetailGame.swift
//  GameApp
//
//  Created by Wahid Hidayat on 05/08/21.
//

import Foundation

struct DetailGame: Codable {
    let id: Int
    let name: String
    let released: String
    let poster: String
    let rating: Double
    let backgroundImage: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case poster = "background_image"
        case rating
        case backgroundImage = "background_image_additional"
        case description
    }
}
