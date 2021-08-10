//
//  Constant.swift
//  GameApp
//
//  Created by Wahid Hidayat on 04/08/21.
//

import Foundation

struct Constant {
    static let baseUrl = "https://api.rawg.io/api/"
    static let listGamesUrl = baseUrl + "games"
    static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "RAWG-Info", ofType: "plist") else {
          fatalError("Couldn't find file 'RAWG-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'RAWG-Info.plist'.")
        }
        return value
    }
}
