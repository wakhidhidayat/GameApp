//
//  Util.swift
//  GameApp
//
//  Created by Wahid Hidayat on 05/08/21.
//

import Foundation

class Util {
    static func formatDate(from dateString: String) -> String? {
        let date = dateString.convertDateString()
        if let date = date {
            return date.convertToString()
        }
        return nil
    }
    
    static func removeHTMLTags(in overview: String) -> String? {
        overview.trimHTMLTags()
    }
}
