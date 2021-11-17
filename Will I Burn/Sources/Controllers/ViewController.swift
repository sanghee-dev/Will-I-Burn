//
//  ViewController.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/07/16.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var skinTypeLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var setReminderBtn: UIButton!
    
    @IBAction func changeSkinBtnTap(_ sender: UIButton) {
        changeSkinBtnTap()
    }
    @IBAction func setReminderBtnTap(_ sender: UIButton) {
        setReminderBtnTap()
    }
    
    var locationManager = CLLocationManager()

    var coords: CLLocationCoordinate2D?
    var uvIndex: Double = 10
    var burnTimeMinutes: Int = 10
    
    var skinType: SkinType = UserDefaultsManager.shared.getSkinType() {
        didSet {
            updateSkinLabel()
            UserDefaultsManager.shared.setSkinType(skinType)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        updateSkinLabel()
    }
}

extension ViewController {
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
}

private extension ViewController {
    func getWeatherData() {
        if let cds = coords {
            let url = WeatherAPI(lat: String(cds.latitude), lon: String(cds.longitude)).getFullWeatherUrl()
            AF.request(url).responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    if let JSON = value as? [String: Any] {
                        let data = JSON["data"] as? Array<Any>
                        let vals = data?[0]
                        if let d = vals as? [String: Any] {
                            if let uv = d["uv"] as? Double {
                                self.uvIndex = uv
                                print(uv)
                                self.updateUI(dataSuccess: true)
                                break
                            }
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                    self.updateUI(dataSuccess: false)
                }
            }
        }
    }
}

private extension ViewController {
    func updateUI(dataSuccess: Bool) {
        DispatchQueue.main.async {
            if !dataSuccess {
                self.getWeatherData()
                return
            }
            self.burnTimeMinutes = Int(BurnTimeManager.shared.calcBurnTime(self.skinType, self.uvIndex))
            self.minutesLabel.text = String(self.burnTimeMinutes)
            self.activityIndicator.stopAnimating()
            self.setReminderBtn.isEnabled = true
        }
    }
    
    func changeSkinBtnTap() {
        let alert = UIAlertController(title: "Pink one", message: "Please choose your skin type", preferredStyle: .actionSheet)
        for skinType in SkinType.allCases {
            alert.addAction(UIAlertAction(title: skinType.rawValue, style: .default, handler: { [weak self] _ in
                self?.skinType = skinType
                self?.updateSkinLabel()
                self?.updateUI(dataSuccess: true)
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func setReminderBtnTap() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if !granted {
                return
            }
            let content = UNMutableNotificationContent()
            content.title = "Time's Up!"
            content.body = "You are beginning to BURN! Please get in to the shade or use strong sunblock and cover up!"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(self.burnTimeMinutes * 60), repeats: false)
            let request = UNNotificationRequest(identifier: "burnNotification", content: content, trigger: trigger)
            center.add(request, withCompletionHandler: nil)
        }
        
        Utilities().showAlert(title: "Reminder", message: "We will remind you after \(self.burnTimeMinutes) minutes!", vc: self)
    }
    
    func updateSkinLabel() {
        skinTypeLabel.text = skinType.rawValue
    }
}
