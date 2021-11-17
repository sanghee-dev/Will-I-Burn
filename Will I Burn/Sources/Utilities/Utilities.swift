//
//  Utilities.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/07/16.
//

import UIKit

class Utilities {
    func showAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
