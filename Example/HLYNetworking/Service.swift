//
//  Service.swift
//  HLYNetworking_Example
//
//  Created by Lingye Han on 2021/2/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire
import HLYNetworking

public enum ResultCode: Int {
    case success = 0
}
public struct Response<T: Model>: Model {
    var code: String
    var message: String
    var result: T?
}

public struct ResponseBool: Model {
    var code: String
    var message: String
    var result: Bool
    
}

class Service {
    var networking: Networking

    init() {
        let baseURL = "https://httpbin.org"
        let headers: [String: String] = [
            "User-Agent": Bundle.main.userAgent
        ]
        networking = Networking(baseURL: baseURL, headers: headers)
    }
    
    public func get<T: Model>(_ request: HLYNetworking.Request, completion: @escaping (Result<T, Error>) -> Void) {
        requestJSONData(.get, request: request, completion: completion)
    }
    
    public func post<T: Model>(_ request: HLYNetworking.Request, completion: @escaping (Result<T, Error>) -> Void) {
        requestJSONData(.get, request: request, completion: completion)
    }
    
    private func requestJSONData<T: Model>(_ method: HTTPMethod, request: HLYNetworking.Request, completion: @escaping (Result<T, Error>) -> Void) {
        let responseCompletion: ((Result<Response<T>, Error>) -> Void) = { result in
            switch result {
            case .success(let response):
                let code = Int(response.code)!
                if ResultCode(rawValue: code) == .success, let result = response.result {
                    completion(.success(result))
                } else {
                    let error = NSError(domain: kRequestErrorDomain, code: code, userInfo: ["message": response.message]) as Error
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        networking.requestJSONData(method, request: request, completion: responseCompletion)
    }
    
    func requestData(_ method: HTTPMethod, request: HLYNetworking.Request, completion: @escaping (Result<Bool, Error>) -> Void) {
        let responseCompletion: ((Result<ResponseBool, Error>) -> Void) = { result in
            switch result {
            case .success(let response):
                let code = Int(response.code)!
                if ResultCode(rawValue: code) == .success {
                    completion(.success(response.result))
                } else {
                    let error = NSError(domain: kRequestErrorDomain, code: code, userInfo: ["message": response.message]) as Error
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        networking.requestJSONData(method, request: request, completion: responseCompletion)
    }
}

public struct Member: Model {
    var nickname: String
    var headImage: String
    var phone: String
    var level: Int
}
class ModuleService: Service {
    
    func fetchMember(completion: @escaping (Result<Member, Error>) -> Void) {
        let request = Request(path: "/status/200")
        request.isCache = true
        get(request, completion: completion)
    }

}
