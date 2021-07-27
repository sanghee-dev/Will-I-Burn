import Foundation

class BurnTime {
    let bt1: Double = 67
    let bt2: Double = 100
    let bt3: Double = 200
    let bt4: Double = 300
    let bt5: Double = 400
    let bt6: Double = 500
    
    private var uvIndex: Double = 10
    
    func calcBurnTime(skinType: String, uvIndex: Double) -> Int {
        self.uvIndex = uvIndex
        
        switch skinType {
        case SkinType().type1:
            return _calcBurnTime(skinTypeBurnIndex: bt1)
        case SkinType().type2:
            return _calcBurnTime(skinTypeBurnIndex: bt2)
        case SkinType().type3:
            return _calcBurnTime(skinTypeBurnIndex: bt3)
        case SkinType().type4:
            return _calcBurnTime(skinTypeBurnIndex: bt4)
        case SkinType().type5:
            return _calcBurnTime(skinTypeBurnIndex: bt5)
        case SkinType().type6:
            return _calcBurnTime(skinTypeBurnIndex: bt6)
        default:
            return 5
        }
    }
    
    private func _calcBurnTime(skinTypeBurnIndex: Double) -> Int {
        if uvIndex == 0 {
            uvIndex = 0.5
        }
        let burnTime = skinTypeBurnIndex / self.uvIndex
        return Int(burnTime)
    }
    
}
