//
//  UserDefaultsManager.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/11/17.
//

import Foundation
import UIKit

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    private let SKINTYPE = "skinType"

    private init() {}
}

extension UserDefaultsManager {
    func getSkin() -> Skin {
        if let rawValue = defaults.string(forKey: SKINTYPE), let type = SkinType(rawValue: rawValue) {
            return Skin(type: type)
        }
        return Skin(type: .pale)
    }

    func setSkinType(_ type: SkinType) {
        defaults.setValue(type.rawValue, forKey: SKINTYPE)
        defaults.synchronize()
    }
}
