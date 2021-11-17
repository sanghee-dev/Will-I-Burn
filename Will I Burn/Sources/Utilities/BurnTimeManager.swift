import Foundation

class BurnTimeManager {
    static let shared = BurnTimeManager()
    var uvIndex: Double = 10
    
    let bt1: Double = 67
    let bt2: Double = 100
    let bt3: Double = 200
    let bt4: Double = 300
    let bt5: Double = 400
    let bt6: Double = 500
}

extension BurnTimeManager {
    func calcBurnTime(skinType: String, uvIndex: Double) -> Int {
        self.uvIndex = uvIndex
        
        switch skinType {
        case SkinType().type1:
            return calcBurnTime(skinTypeBurnIndex: bt1)
        case SkinType().type2:
            return calcBurnTime(skinTypeBurnIndex: bt2)
        case SkinType().type3:
            return calcBurnTime(skinTypeBurnIndex: bt3)
        case SkinType().type4:
            return calcBurnTime(skinTypeBurnIndex: bt4)
        case SkinType().type5:
            return calcBurnTime(skinTypeBurnIndex: bt5)
        case SkinType().type6:
            return calcBurnTime(skinTypeBurnIndex: bt6)
        default:
            return 5
        }
    }
    
    func calcBurnTime(skinTypeBurnIndex: Double) -> Int {
        if uvIndex < 0.5 { uvIndex = 0.5 }
        let burnTime = skinTypeBurnIndex / uvIndex
        return Int(burnTime)
    }
}
