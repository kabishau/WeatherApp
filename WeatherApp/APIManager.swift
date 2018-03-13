import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String: Any]?, HTTPURLResponse?, Error?) -> Void

// generic enum, in this specific case should be type of CustomWeather
enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

// protocol/interface for working with network

protocol APIManager {
    
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func JSONTaskWith(request: URLRequest, completionHandler: JSONCompletionHandler) -> JSONTask
    // using generic
    func fetch<T>(request: URLRequest, parse: ([String: AnyObject]) -> T?, completionHandler: (APIResult<T>) -> Void)
    
    // to define type of session configuration
    init(sessionConfiguration: URLSessionConfiguration)
    
}

extension APIManager {
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                // empty array for using in NSError
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                let error = NSError(domain: SWINetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completionHandler(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completionHandler(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        completionHandler(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completionHandler(nil, HTTPResponse, error)
                    }
                default:
                    print("We have got response status \(HTTPResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
}
