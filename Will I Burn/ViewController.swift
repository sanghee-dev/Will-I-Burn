//
//  ViewController.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/07/16.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var skinTypeLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            getLocation()
        } else {
            print("loc denied")
            let alert = UIAlertController(title: "Error!", message: "Please allow location services for Will I Burn. Or else we can't be of any use!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getLocation() {
        
    }
    
    @IBAction func changeSkinBtnTap(_ sender: UIButton) {
    }
    @IBAction func setReminderBtnTap(_ sender: UIButton) {
    }
    
}
