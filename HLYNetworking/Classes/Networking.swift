//
//  Networking.swift
//  HLYNetworking
//
//  Created by Lingye Han on 2020/9/11.
//

import Foundation
import Alamofire

public class Networking {
    var session: Session
    weak var request: Alamofire.Request?
    
    fileprivate var baseURL: String

    public init(baseURL: String, headers: [String: String]? = nil, configuration: URLSessionConfiguration = URLSessionConfiguration.af.default) {
        self.baseURL = baseURL
        configuration.httpAdditionalHeaders = headers
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
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
                debugPrint("[HLYNetworking] Response Data:\n \(response.data.json)")
                
                var object: T?
                do {
                    object = try JSONCoder.decode(data: response.data)
       
                    completion(.success(object!))
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
        guard let url = try? urlString.asURL() else { fatalError("Invalid URL: \(urlString)") }
 
        var encoding: ParameterEncoding = URLEncoding.default
        if let type = request.encodingType {
            encoding = type
        } else {
            if method == .post || method == .put || method == .patch {
                encoding = JSONEncoding.default
            }
        }
        self.request = session.request(url, method: method, parameters: request.parameters, encoding: encoding, headers: nil)
            //.validate(statusCode: 200..<300)
            .response(completionHandler: { response in
                
                if let statusCode = response.response?.statusCode, statusCode > 200 {
                    let error = response.error ?? NSError(
                                domain: kRequestErrorDomain,
                                code: statusCode,
                                userInfo: ["data": response.data?.json ?? [:]]
                             ) as Error
                    completion(.failure(error))
                    return
                }
                guard let data = response.data else {
                    fatalError("Response data is null")
                }
                
                let response = Response(data: data,
                         headers: response.response?.allHeaderFields as? [String: Any])
                completion(.success(response))
            })
    }
    
    public func cancel() {
        request?.cancel()
    }
}
