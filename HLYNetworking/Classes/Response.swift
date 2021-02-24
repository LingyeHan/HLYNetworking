//
//  Response.swift
//  HLYNetworking
//
//  Created by Lingye Han on 2021/2/23.
//

import Foundation

public struct Response {
    
    public let data: Data
    public let headers: [String: Any]?
    
    public init(data: Data, headers: [String: Any]?) {
        self.data = data
        self.headers = headers
    }
}
