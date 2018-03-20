import Foundation
import UIKit

struct CurrentWeather {
    
    let temperature: Double
    let apparentTemperature: Double
    let humidity: Double
    let pressure: Double
    let icon: UIImage
    
}

extension CurrentWeather: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let temperature = JSON["temperature"] as? Double,
        let apparentTemperature = JSON["apparentTemperature"] as? Double,
            let humidity = JSON["humidity"] as? Double,
            let pressure = JSON["pressure"] as? Double,
            let iconString = JSON["icon"] as? String else {
                return nil
        }
        
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.humidity = humidity
        self.pressure = pressure
        self.icon = WeatherIconManager(rawValue: iconString).image
        
    }
    
}

extension CurrentWeather {
    var pressureString: String {
        return "\(Int(pressure)) mm"
    }
    var humidityString: String {
        return "\(Int(humidity)) %"
    }
    var temperatureString: String {
        return "\(Int(temperature))˚C"
    }
    var appearentTemperatureString: String {
        return "\(Int(apparentTemperature))˚C"
    }
}
