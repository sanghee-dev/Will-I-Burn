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
    
    private init() {}
}

extension BurnTimeManager {
    func calcBurnTime(_ skinType: SkinType, _ uvIndex: Double) -> Int {
        self.uvIndex = (uvIndex > 0.5) ? uvIndex : 0.5
        
        switch skinType {
        case .type1: return Int(SkinTime.time1.rawValue / self.uvIndex)
        case .type2: return Int(SkinTime.time2.rawValue / self.uvIndex)
        case .type3: return Int(SkinTime.time3.rawValue / self.uvIndex)
        case .type4: return Int(SkinTime.time4.rawValue / self.uvIndex)
        case .type5: return Int(SkinTime.time5.rawValue / self.uvIndex)
        case .type6: return Int(SkinTime.time6.rawValue / self.uvIndex)
        }
    }
}
