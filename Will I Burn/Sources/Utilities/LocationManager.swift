//
//  LocationManager.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/11/18.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    let manager = CLLocationManager()
    
    private override init() {}
    
    func startLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            checkAuthorizationStatus()
        }
    }
    
    func checkAuthorizationStatus() {
        var status: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            status = CLLocationManager().authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .authorizedAlways, .authorized, .authorizedWhenInUse: manager.startUpdatingLocation()
        case .notDetermined: manager.requestWhenInUseAuthorization()
        case .restricted, .denied: manager.requestWhenInUseAuthorization()
        @unknown case _: manager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            postNotification("coordinate", ["coordinate": location.coordinate])
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
    
    func postNotification(_ name: String, _ userInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: nil, userInfo: userInfo)
    }
}
