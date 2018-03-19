import Foundation

// final - no one can inherit this class
final class APIWeatherManager: APIManager {
    
    var sessionConfiguration: URLSessionConfiguration
    
    // this session will be created only when we start using it
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    let apiKey: String
    
    init(sessionConfiguration: URLSessionConfiguration, apiKey: String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    
    // conveniece init - because almost every time we gonna use defalt session configuration
    convenience init(apiKey: String) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
    }

}
