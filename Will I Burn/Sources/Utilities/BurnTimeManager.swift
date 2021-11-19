//
//  BurnTimeManager.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/07/16.
//

import Foundation

final class BurnTimeManager {
    static let shared = BurnTimeManager()

    private init() {}
}

extension BurnTimeManager {
    func calcBurnTime(_ skinType: SkinType, _ uvIndex: Double) -> Int {
        let uvIndex = (uvIndex > 0.5) ? uvIndex : 0.5
        switch skinType {
        case .pale: return Int(SkinTime.pale.rawValue / uvIndex)
        case .fair: return Int(SkinTime.fair.rawValue / uvIndex)
        case .medium: return Int(SkinTime.medium.rawValue / uvIndex)
        case .olive: return Int(SkinTime.olive.rawValue / uvIndex)
        case .brown: return Int(SkinTime.brown.rawValue / uvIndex)
        case .dark: return Int(SkinTime.dark.rawValue / uvIndex)
        }
    }
}
