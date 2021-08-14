//
//  Profile.swift
//  GameApp
//
//  Created by Wahid Hidayat on 13/08/21.
//

import Foundation

struct Profile {
    static let nameKey = "name"
    static let addressKey = "address"
    static let occupationKey = "occupation"
    static let hobbiesKey = "hobbies"
    
    static var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }
    
    static var address: String {
        get {
            return UserDefaults.standard.string(forKey: addressKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: addressKey)
        }
    }
    
    static var occupation: String {
        get {
            return UserDefaults.standard.string(forKey: occupationKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: occupationKey)
        }
    }
    
    static var hobbies: String {
        get {
            return UserDefaults.standard.string(forKey: hobbiesKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hobbiesKey)
        }
    }
    
    static func synchronize() {
        UserDefaults.standard.synchronize()
    }
}
