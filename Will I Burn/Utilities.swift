import Foundation

class Utilities {
    let skinTypeKey = "skinType"
    
    func getStorage() -> UserDefaults {
        return UserDefaults.standard
    }
    
    func setSkinType(value: String) {
        let defaults = getStorage()
        defaults.setValue(value, forKey: skinTypeKey)
        defaults.synchronize()
    }
    
    func getSkinType() -> String {
        let defaults = getStorage()
        if let item = defaults.string(forKey: skinTypeKey) {
            return item
        }
        return SkinType().type1
    }
    
}
