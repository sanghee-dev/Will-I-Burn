//
//  ViewController.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/07/16.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var skinTypeLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var setReminderBtn: UIButton!
    
    @IBAction func changeSkinBtnTap(_ sender: UIButton) { skinBtnTapped() }
    @IBAction func setReminderBtnTap(_ sender: UIButton) { reminderBtnTapped() }
    
    var burnTime: Int = 10
    var coordinate: CLLocationCoordinate2D = .init() {
        didSet { getWeatherData() }
    }
    var uvIndex: Double = 10 {
        didSet { updateUI() }
    }
    var skinType: SkinType = UserDefaultsManager.shared.getSkinType() {
        didSet { updateUI() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocation()
    }
}

extension ViewController {
    func configureLocation() {
        LocationManager.shared.startLocationAuthorization()
        NotificationMananger.shared.center.addObserver(self, selector: #selector(locationSuccess(_:)), name: Notification.Name("coordinate"), object: nil)
    }
    
    @objc func locationSuccess(_ notification: NSNotification) {
        if let coordinate = notification.userInfo?["coordinate"] as? CLLocationCoordinate2D {
            self.coordinate = coordinate
        }
    }
    
    func getWeatherData() {
        WeatherManager.shared.getWeatherUV(coordinate) { result in
            switch result {
            case .success(let uv): self.uvIndex = uv
            case .failure(let error): self.showAlert("Error", error.localizedDescription)
            }
        }
    }
}

private extension ViewController {
    func skinBtnTapped() {
        let alert = UIAlertController(title: "Pink one", message: "Please choose your skin type", preferredStyle: .actionSheet)
        for skinType in SkinType.allCases {
            alert.addAction(UIAlertAction(title: skinType.rawValue, style: .default, handler: { [weak self] _ in
                self?.skinType = skinType
                UserDefaultsManager.shared.setSkinType(skinType)
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func reminderBtnTapped() {
        UserNotificationMananger.shared.requestNotification(after: burnTime)
        showAlert("Reminder", "We will remind you after \(burnTime) minutes!")
    }
}

private extension ViewController {
    func updateUI() {
        skinTypeLabel.text = skinType.rawValue
        burnTime = Int(BurnTimeManager.shared.calcBurnTime(skinType, uvIndex))
        minutesLabel.text = String(burnTime)
        setReminderBtn.isEnabled = true
        activityIndicator.stopAnimating()
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
