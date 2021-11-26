//
//  MainViewController.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/07/16.
//

import UIKit
import CoreLocation
import Combine
import CombineCocoa

final class MainViewController: UIViewController {

    @IBOutlet weak var skinColorView: UIView!
    @IBOutlet weak var skinTypeLabel: UILabel!
    @IBOutlet weak var skinTypeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var burnTimeLabel: UILabel!
    @IBOutlet weak var minutesSentenceLabel: UILabel!
    @IBOutlet weak var reminderButton: UIButton!

    private var skin: Skin = UserDefaultsManager.shared.getSkin() {
        didSet { calculateBurnTime() }
    }
    private var uvIndex: Double = 10 {
        didSet { calculateBurnTime() }
    }
    private var coordinate: CLLocationCoordinate2D = .init() {
        didSet { getWeatherData() }
    }
    private var burnTime: Int = 0 {
        didSet { updateUI() }
    }

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocation()
        configureSkinLabel()
        setPublisher()
    }
}

private extension MainViewController {
    func setPublisher() {
        skinTypeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let alert = UIAlertController(title: "Skin Type", message: "Please choose your skin type", preferredStyle: .actionSheet)
                for type in SkinType.allCases {
                    alert.addAction(UIAlertAction(title: type.rawValue, style: .default, handler: { [weak self] _ in
                        self?.skin = Skin(type: type)
                        UserDefaultsManager.shared.setSkinType(type)
                    }))
                }
                self.present(alert, animated: true, completion: nil)
            }.store(in: &cancellables)

        reminderButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                UserNotificationMananger.shared.requestNotification(after: self.burnTime)
                self.showAlert("Reminder", "We will remind you after \(self.burnTime) minutes!")
            }.store(in: &cancellables)
    }
}

private extension MainViewController {
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
        burnTime = Int(BurnTimeManager.shared.calcBurnTime(skin.type, uvIndex))
    }
}

private extension MainViewController {
    func configureSkinLabel() {
        skinColorView.backgroundColor = skin.color
        skinTypeLabel.text = skin.type.rawValue
    }

    func updateUI() {
        skinColorView.alpha = 1
        skinTypeLabel.alpha = 1
        minutesSentenceLabel.alpha = 1

        skinColorView.backgroundColor = skin.color
        skinTypeLabel.text = skin.type.rawValue
        burnTimeLabel.text = String(burnTime)

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

