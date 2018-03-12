import Foundation

// protocol/interface for working with network

protocol APIManager {
    
    var sessionConfiguration: URLSessionConfiguration { get }
    var URLSession: URLSession { get }
    
    func JSONTaskWith(request: URLRequest, completionHandler: ([String: Any]?, HTTPURLResponse?, Error?)) -> URLSessionDataTask
    
    // to define type of session configuration
    init(sessionConfiguration: URLSessionConfiguration)
    
}
