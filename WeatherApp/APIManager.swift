import Foundation

// protocol/interface for working with network

protocol APIManager {
    
    typealias JSONTask = URLSessionDataTask
    typealias JSONCompletionHandler = ([String: Any]?, HTTPURLResponse?, Error?)
    
    var sessionConfiguration: URLSessionConfiguration { get }
    var URLSession: URLSession { get }
    
    func JSONTaskWith(request: URLRequest, completionHandler: JSONCompletionHandler) -> JSONTask
    
    // to define type of session configuration
    init(sessionConfiguration: URLSessionConfiguration)
    
}
