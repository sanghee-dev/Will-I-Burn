//
//  ViewController.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/07/16.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var skinTypeLabel: UILabel!
    @IBOutlet weak var skinTypeButton: UIButton!
    @IBOutlet weak var burnTimeLabel: UILabel!
    @IBOutlet weak var minutesSentenceLabel: UILabel!
    @IBOutlet weak var reminderButton: UIButton!
    
    @IBAction func skinButtonTapped(_ sender: UIButton) { skinButtonTapped() }
    @IBAction func reminderButtonTapped(_ sender: UIButton) { reminderButtonTapped() }
    
    private var burnTime: Int = 10 {
        didSet {
            updateUI()
        }
    }
    private var coordinate: CLLocationCoordinate2D = .init() {
        didSet {
            getWeatherData()
        }
    }
    private var uvIndex: Double = 10 {
        didSet {
            calculateBurnTime()
        }
    }
    private var skinType: SkinType = UserDefaultsManager.shared.getSkinType() {
        didSet {
            calculateBurnTime()
        }
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
    
    func calculateBurnTime() {
        burnTime = Int(BurnTimeManager.shared.calcBurnTime(skinType, uvIndex))
    }
}

private extension ViewController {
    func skinButtonTapped() {
        let alert = UIAlertController(title: "Pink one", message: "Please choose your skin type", preferredStyle: .actionSheet)
        for skinType in SkinType.allCases {
            alert.addAction(UIAlertAction(title: skinType.rawValue, style: .default, handler: { [weak self] _ in
                self?.skinType = skinType
                UserDefaultsManager.shared.setSkinType(skinType)
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func reminderButtonTapped() {
        UserNotificationMananger.shared.requestNotification(after: burnTime)
        showAlert("Reminder", "We will remind you after \(burnTime) minutes!")
    }
}

private extension ViewController {
    func updateUI() {
        skinTypeLabel.alpha = 1
        skinTypeLabel.text = skinType.rawValue
        burnTimeLabel.text = String(burnTime)
        minutesSentenceLabel.alpha = 1
        
        skinTypeButton.isEnabled = true
        reminderButton.isEnabled = true
        activityIndicator.stopAnimating()
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
