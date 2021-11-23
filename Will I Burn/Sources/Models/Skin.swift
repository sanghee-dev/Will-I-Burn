//
//  Skin.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/11/19.
//

import UIKit

class Skin {
    let type: SkinType
    let time: SkinTime
    let color: UIColor

    init(type: SkinType, time: SkinTime, color: UIColor) {
        self.type = type
        self.time = time
        self.color = color
    }

    convenience init(type: SkinType) {
        switch type {
        case .pale: self.init(type: type, time: .pale, color: .paleSkin)
        case .fair: self.init(type: type, time: .fair, color: .fairSkin)
        case .medium: self.init(type: type, time: .medium, color: .mediumSkin)
        case .olive: self.init(type: type, time: .olive, color: .oliveSkin)
        case .brown: self.init(type: type, time: .brown, color: .brownSkin)
        case .dark: self.init(type: type, time: .dark, color: .darkSkin)
        }
    }
}
