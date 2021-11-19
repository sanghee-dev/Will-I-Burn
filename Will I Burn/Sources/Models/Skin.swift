//
//  Skin.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/11/19.
//

import UIKit

struct Skin {
    let type: SkinType
    let time: SkinTime
    let color: UIColor

    init(type: SkinType) {
        self.type = type

        switch type {
        case .pale:
            time = .pale
            color = .paleSkin
        case .fair:
            time = .fair
            color = .fairSkin
        case .medium:
            time = .medium
            color = .mediumSkin
        case .olive:
            time = .olive
            color = .oliveBrownSkin
        case .brown:
            time = .brown
            color = .brownSkin
        case .dark:
            time = .dark
            color = .darkBrownSkin
        }
    }
}
