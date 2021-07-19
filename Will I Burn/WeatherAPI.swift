import Foundation

struct WeatherAPI {
    
    private let baseUrl = "https://api.weatherbit.io/v2.0/current?"
    private let key = "83b573f898c44511bc811d7c795d29d9"
    private var coord = ""
    
    init(lat: String, lon: String) {
        self.coord = "&lat=\(lat)&lon=\(lon)"
    }
    
    func getFullWeatherUrl() -> String {
        return baseUrl + coord + key
    }
    
}
