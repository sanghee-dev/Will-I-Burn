//
//  ViewController.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/07/16.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var skinTypeLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    
    var locationManager = CLLocationManager()

    var coords: CLLocationCoordinate2D?
    
    var skinType: String = Utilities().getSkinType() {
        didSet {
            updateSkinLabel()
            Utilities().setSkinType(value: skinType)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        updateSkinLabel()
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
        if let loc = locationManager.location {
            coords = loc.coordinate
            getWeatherData()
        }
    }
    
    func getWeatherData() {
        if let cds = coords {
            let url = WeatherAPI(lat: String(cds.latitude), lon: String(cds.longitude)).getFullWeatherUrl()
            AF.request(url).responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Success")
                    print(value)
                case .failure(let error):
                    print("Failure")
                    print(error)
                }
            }
        }
    }
    
    @IBAction func changeSkinBtnTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "Pink one", message: "Please choose your skin type", preferredStyle: .actionSheet)
        for skin in SkinType().allSkinTypes() {
            alert.addAction(UIAlertAction(title: skin, style: .default, handler: { (action) in
                self.skinType = skin
                self.updateSkinLabel()
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func setReminderBtnTap(_ sender: UIButton) {
        
    }
    
    func updateSkinLabel() {
        skinTypeLabel.text = skinType
    }
    
}


