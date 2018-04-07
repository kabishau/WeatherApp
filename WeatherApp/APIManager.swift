import Foundation
//
////typealias JSONTask = URLSessionDataTask
////typealias JSONCompletionHandler = ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void

//
protocol JSONDecodable {
    init?(JSON: [String: AnyObject])
}

protocol FinalURLPoint {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

// generic T gives the opportunity to send specific type in case of Success and Error in case of failure
enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

protocol APIManager {

    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }

    //func JSONTaskWith(request: URLRequest, completionHandler: JSONCompletionHandler) -> JSONTask
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask

    func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)

    // init is included in APIWeatherManager
    //init(sessionConfiguration: URLSessionConfiguration)

}

extension APIManager {
    
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            // checking is the response is a HTTPURLResponse
            guard let HTTPResponse = response as? HTTPURLResponse else {
                // best practice for user info is not to use String: String value
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")]
                let error = NSError(domain: SWINetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completionHandler(nil, nil, error)
                return
            }
            
            // in case if we get HTTPResponse but data is nil or not nil (else)
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
    
    func fetch<T>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completionHandler: @escaping(APIResult<T>) -> Void) {
        
        let dataTask = JSONTaskWith(request: request) { (json, response, error) in
            
            guard let json = json else {
                if let error = error {
                    completionHandler(APIResult.Failure(error))
                }
                return
            }
            
            if let value = parse(json) {
                completionHandler(APIResult.Success(value))
            } else {
                let error = NSError(domain: SWINetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                completionHandler(APIResult.Failure(error))
            }
        }
        dataTask.resume()
    }
}






