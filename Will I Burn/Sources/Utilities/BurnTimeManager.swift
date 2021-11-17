//
//  BurnTimeManager.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/07/16.
//

import Foundation

class BurnTimeManager {
    static let shared = BurnTimeManager()
    var uvIndex: Double = 10
}

extension BurnTimeManager {
    func calcBurnTime(skinType: SkinType, uvIndex: Double) -> Int {
        self.uvIndex = (uvIndex > 0.5) ? uvIndex : 0.5
        
        switch skinType {
        case .type1: return Int(SkinTime.time1.rawValue / uvIndex)
        case .type2: return Int(SkinTime.time2.rawValue / uvIndex)
        case .type3: return Int(SkinTime.time3.rawValue / uvIndex)
        case .type4: return Int(SkinTime.time4.rawValue / uvIndex)
        case .type5: return Int(SkinTime.time5.rawValue / uvIndex)
        case .type6: return Int(SkinTime.time6.rawValue / uvIndex)
        }
    }
}
