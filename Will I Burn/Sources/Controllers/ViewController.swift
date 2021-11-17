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

    var coordinate: CLLocationCoordinate2D?
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
        let status = manager.authorizationStatus
        switch status {
        case .authorizedAlways: getLocation()
        case .authorizedWhenInUse: getLocation()
        case .authorized: getLocation()
        case .notDetermined: getLocation()
        case .restricted: showAlert("Error!", "Please allow location services")
        case .denied: showAlert("Error!", "Please allow location services")
        @unknown default: showAlert("Error!", "Please allow location services")
        }
    }
    
    func getLocation() {
        if let location = locationManager.location {
            coordinate = location.coordinate
            getWeatherData()
        }
    }
}

private extension ViewController {
    func getWeatherData() {
        if let coordinate = coordinate {
            let url = WeatherAPI(lat: String(coordinate.latitude), lon: String(coordinate.longitude)).getFullWeatherUrl()
            AF.request(url).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        let data = JSON["data"] as? Array<Any>
                        let vals = data?[0]
                        if let d = vals as? [String: Any] {
                            if let uv = d["uv"] as? Double {
                                self.uvIndex = uv
                                self.updateUI(dataSuccess: true)
                                break
                            }
                        }
                    }
                case .failure(let error):
                    self.showAlert("Error", error.localizedDescription)
                    self.updateUI(dataSuccess: false)
                }
            }
        }
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        
        showAlert("Reminder", "We will remind you after \(burnTimeMinutes) minutes!")
    }
    
    func updateSkinLabel() {
        skinTypeLabel.text = skinType.rawValue
    }
}
