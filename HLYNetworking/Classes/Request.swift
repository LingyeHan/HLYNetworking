//
//  Request.swift
//  HLYNetworking
//
//  Created by Lingye Han on 2021/2/23.
//

import Foundation
import Alamofire

open class Request: CustomStringConvertible {

    open var baseUrl: String?
    open var path: String
    open var encodingType: ParameterEncoding?
    open var parameters: [String: Any]?
    open var isCache: Bool
    open var refreshCache: Bool

    public init(
        baseUrl: String? = nil,
        path: String,
        encodingType: ParameterEncoding? = nil,
        parameters: [String: Any]? = nil,
        isCache: Bool = false,
        refreshCache: Bool = true) {
        
        self.baseUrl = baseUrl
        self.path = path
        self.encodingType = encodingType
        self.parameters = parameters
        self.isCache = isCache
        self.refreshCache = refreshCache
    }
    
    public var description: String {
        return ["baseUrl": baseUrl ?? "", "path": path, "encodingType": encodingType ?? "", "parameters": parameters ?? "", "isCache": isCache, "refreshCache": refreshCache].description
    }
}
