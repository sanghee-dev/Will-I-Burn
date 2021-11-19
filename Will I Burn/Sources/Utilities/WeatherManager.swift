//
//  WeatherManager.swift
//  Will I Burn
//
//  Created by leeesangheee on 2021/11/18.
//

import Foundation
import Alamofire
import CoreLocation

final class WeatherManager {
    static let shared = WeatherManager()

    private init() {}

    private func getWeatherUrl(_ coordinate: CLLocationCoordinate2D) -> String {
        let baseUrl = "https://api.weatherbit.io/v2.0/current?"
        let key = "&key=83b573f898c44511bc811d7c795d29d9"
        let params = "&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)"

        return baseUrl + params + key
    }
}

extension WeatherManager {
    func getWeatherUV(_ coordinate: CLLocationCoordinate2D, _ completion: @escaping (Result<Double, Error>) -> Void) {
        let url = getWeatherUrl(coordinate)

        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String: Any] {
                    let data = JSON["data"] as? [Any]
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
