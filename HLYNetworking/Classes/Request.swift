//
//  Request.swift
//  HLYNetworking
//
//  Created by Lingye Han on 2021/2/23.
//

import Foundation
import Alamofire

open class Request {
    
    open var baseUrl: String?
    open var path: String
    open var encodingType: ParameterEncoding?
    open var parameters: [String: Any]?

    public init(
        baseUrl: String? = nil,
        path: String,
        encodingType: ParameterEncoding? = nil,
        parameters: [String: Any]? = nil) {
        
        self.baseUrl = baseUrl
        self.path = path
        self.encodingType = encodingType
        self.parameters = parameters
    }
}
