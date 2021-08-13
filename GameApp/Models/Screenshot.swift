//
//  Screenshot.swift
//  GameApp
//
//  Created by Wahid Hidayat on 13/08/21.
//

import Foundation

struct ScreenshotResult: Codable {
    let results: [Screenshot]
}

struct Screenshot: Codable {
    let image: String
}
