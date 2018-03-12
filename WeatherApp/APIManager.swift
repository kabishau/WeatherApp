import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String: Any]?, HTTPURLResponse?, Error?)

// generic enum, in this specific case should be type of CustomWeather
enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

// protocol/interface for working with network

protocol APIManager {
    
    var sessionConfiguration: URLSessionConfiguration { get }
    var URLSession: URLSession { get }
    
    func JSONTaskWith(request: URLRequest, completionHandler: JSONCompletionHandler) -> JSONTask
    // using generic
    func fetch<T>(request: URLRequest, parse: ([String: AnyObject]) -> T?, completionHandler: (APIResult<T>) -> Void)
    
    // to define type of session configuration
    init(sessionConfiguration: URLSessionConfiguration)
    
}
