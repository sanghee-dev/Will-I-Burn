//
//  WeatherManager.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/11/18.
//

import Foundation
import Alamofire
import CoreLocation

class WeatherManager {
    static let shared = WeatherManager()
    
    private init() {}
}

extension WeatherManager {
    func getWeatherUV(_ coordinate: CLLocationCoordinate2D, _ completion: @escaping (Result<Double, Error>) -> Void) {
        let url = WeatherAPI(lat: String(coordinate.latitude), lon: String(coordinate.longitude)).getFullWeatherUrl()
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String: Any] {
                    let data = JSON["data"] as? Array<Any>
                    let values = data?[0]
                    if let value = values as? [String: Any] {
                        if let uv = value["uv"] as? Double {
                            completion(.success(uv))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
