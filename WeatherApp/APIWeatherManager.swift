import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

enum ForecastType: FinalURLPoint {
    
    case Current(apiKey: String, coordinates: Coordinates)
    
    var baseURL: URL {
        return URL(string: "https://api.darksky.net")!
    }
    
    var path: String {
        // using self refer to enum itself;
        // because of it doesn't have other then Current option default is not required
        switch self {
        case .Current(let apiKey, let coordinates):
            return "/forecast/\(apiKey)/\(coordinates.latitude),\(coordinates.longitude)"
        }
    }
    
    var request: URLRequest {
        let url = URL(fileURLWithPath: path, relativeTo: baseURL)
        return URLRequest(url: url)
    }
    
}

final class APIWeatherManager: APIManager {
    
    let sessionConfiguration: URLSessionConfiguration
    
    // will be created at the moment when we call it
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    let apiKey: String
    
    // designated init - list all members
    init(sessionConfiguration: URLSessionConfiguration, apiKey: String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    
    // convenience initializer for default session configuration
    convenience init(apiKey: String) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
    }
    
    // method that returns Current Weather
    func fetchCurrentWeatherWith(coordinates: Coordinates, completionHandler: @escaping (APIResult<CurrentWeather>) -> Void) {
        let request = ForecastType.Current(apiKey: self.apiKey, coordinates: coordinates).request
        
        fetch(request: request, parse: { (json) -> CurrentWeather? in
            if let dictionary = json["currently"] as? [String: AnyObject] {
                return CurrentWeather(JSON: dictionary)
            } else {
                return nil
            }
        }, completionHandler: completionHandler)
    }
    
    

    
    
    
    
    
    
    
    
    
}

