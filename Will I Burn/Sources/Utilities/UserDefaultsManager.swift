//
//  UserDefaultsManager.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/11/17.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    let defaults = UserDefaults.standard
    let SKIN_TYPE_KEY = "skinType"
    
    private init() {}
}

extension UserDefaultsManager {
    func getSkinType() -> SkinType {
//        if let item = defaults.string(forKey: SKIN_TYPE_KEY) {
//            return item
//        }
        return SkinType.type1
    }
    
    func setSkinType(_ type: SkinType) {
        defaults.setValue(type.rawValue, forKey: SKIN_TYPE_KEY)
        defaults.synchronize()
    }
}
