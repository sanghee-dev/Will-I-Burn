//
//  Utilities.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/07/16.
//

import UIKit

class Utilities {
    let skinTypeKey = "skinType"
    
    func showAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func getStorage() -> UserDefaults {
        return UserDefaults.standard
    }
    
    func setSkinType(_ type: SkinType) {
        let defaults = getStorage()
        defaults.setValue(type.rawValue, forKey: skinTypeKey)
        defaults.synchronize()
    }
    
    func getSkinType() -> SkinType {
        let defaults = getStorage()
//        if let item = defaults.string(forKey: skinTypeKey) {
//            return item
//        }
        return SkinType.type1
    }
    
}
