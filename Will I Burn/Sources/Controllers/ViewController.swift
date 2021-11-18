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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var setReminderBtn: UIButton!
    
    @IBAction func changeSkinBtnTap(_ sender: UIButton) { changeSkinBtnTap() }
    @IBAction func setReminderBtnTap(_ sender: UIButton) { setReminderBtnTap() }
    
    var uvIndex: Double = 10
    var burnTime: Int = 10
    var skinType: SkinType = UserDefaultsManager.shared.getSkinType() {
        didSet {
            updateSkinLabel()
            UserDefaultsManager.shared.setSkinType(skinType)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLocation()
        updateSkinLabel()
    }
}

extension ViewController {
    func configureLocation() {
        LocationManager.shared.startLocationAuthorization()
        NotificationMananger.shared.center.addObserver(self, selector: #selector(locationSuccess(_:)), name: Notification.Name("coordinate"), object: nil)
    }
    
    @objc func locationSuccess(_ notification: NSNotification) {
        if let coordinate = notification.userInfo?["coordinate"] as? CLLocationCoordinate2D {
            getWeatherData(coordinate)
        }
    }
    
    func getWeatherData(_ coordinate: CLLocationCoordinate2D) {
        WeatherManager.shared.getWeatherUV(coordinate) { result in
            switch result {
            case .success(let uv):
                self.uvIndex = uv
                self.updateUI(dataSuccess: true)
            case .failure(let error):
                self.showAlert("Error", error.localizedDescription)
            }
        }
    }
}

private extension ViewController {
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateUI(dataSuccess: Bool) {
        if !dataSuccess {
//            getWeatherData()
            return
        }
        burnTime = Int(BurnTimeManager.shared.calcBurnTime(skinType, uvIndex))
        minutesLabel.text = String(burnTime)
        activityIndicator.stopAnimating()
        setReminderBtn.isEnabled = true
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
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(self.burnTime * 60), repeats: false)
            let request = UNNotificationRequest(identifier: "burnNotification", content: content, trigger: trigger)
            center.add(request, withCompletionHandler: nil)
        }
        
        showAlert("Reminder", "We will remind you after \(burnTime) minutes!")
    }
    
    func updateSkinLabel() {
        skinTypeLabel.text = skinType.rawValue
    }
}
