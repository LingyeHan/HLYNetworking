//
//  Networking.swift
//  HLYNetworking
//
//  Created by Lingye Han on 2020/9/11.
//

import Foundation
import Alamofire
//import AlamofireURLCache5

public class Networking {
    var session: Session
    weak var request: Alamofire.Request?
    
    fileprivate var baseURL: String
    let reachability = NetworkReachabilityManager.default

    public init(baseURL: String, headers: [String: String]? = nil, configuration: URLSessionConfiguration = URLSessionConfiguration.af.default) {
        self.baseURL = baseURL
        configuration.httpAdditionalHeaders = headers
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
//        configuration.requestCachePolicy = .returnCacheDataElseLoad
        self.session = Session(configuration: configuration)
    }

    public func get<T: Model>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void) {
        requestJSONData(.get, request: request, completion: completion)
    }
    
    public func post<T: Model>(_ request: Request, parameters: Parameters? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        requestJSONData(.post, request: request, completion: completion)
    }
    
    public func requestJSONData<T: Model>(_ method: HTTPMethod, request: Request, completion: @escaping (Result<T, Error>) -> Void) {
        requestData(method, request: request) { result in
            switch result {
            case .success(let response):
                var object: T
                do {
                    object = try JSONCoder.decode(data: response.data ?? [:].data)
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func requestData(_ method: HTTPMethod, request: Request, completion: @escaping (Result<Response, Error>) -> Void) {
        
        let urlString = "\(request.baseUrl ?? baseURL)\(request.path)"
        guard let url = try? urlString.asURL() else { fatalError("[HLYNetworking] Invalid URL: \(urlString)") }
        
        // Read Cache
        if method == .get, request.isCache {
            if let data = Storage.shared.object(forKey: urlString) as? Data {
                completion(.success(Response(data: data,
                                             headers: ["cache": true])))
                if !request.refreshCache {
                    return
                }
            }
        }
//        if reachability?.isReachable == false {
//            completion(.failure(RequestError.noConnection))
//            return
//        }
 
        let encoding: ParameterEncoding = request.encodingType ?? (method == .get ? .default : JSONEncoding())
//        let cacher = ResponseCacher(behavior: .cache)
        self.request = session.request(url, method: method, parameters: request.parameters, encoding: encoding)
//            .cacheResponse(using: cacher)
            //.validate(statusCode: 200..<300)
            //.responseJSON(completionHandler: { response in
            .response(completionHandler: { response in
                print("[HLYNetworking] Request URL: \(url)\nRequest Headers: \(URLSessionConfiguration.af.default.headers)\nResponse Data:  \(response.data?.json)")
                
                switch response.result {
                case .success(let data):
                    if let statusCode = response.response?.statusCode, statusCode > 200 {
                        let error = response.error ?? NSError(
                                    domain: kRequestErrorDomain,
                                    code: statusCode,
                                    userInfo: data?.json ?? [:]
                                 ) as Error
                        completion(.failure(error))
                        return
                    }
                    
                    // Write Cache
                    if method == .get, request.isCache, let data = response.data {
                        Storage.shared.setObject(data, forKey: urlString)
                    }
                    
                    let response = Response(data: response.data,
                             headers: response.response?.allHeaderFields as? [String: Any])
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
                
                if let notification = request.notification {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: notification, object: nil)
                    }
                }
            })//.cache(maxAge: 6*60*60, isPrivate: false, ignoreServer: true)
    }
    
    public func cancel() {
        request?.cancel()
    }
}
