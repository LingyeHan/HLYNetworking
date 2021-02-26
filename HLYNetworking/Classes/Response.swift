//
//  Response.swift
//  HLYNetworking
//
//  Created by Lingye Han on 2021/2/23.
//

import Foundation

public struct Response: CustomStringConvertible {
    
    public let data: Data?
    public let headers: [String: Any]?
    
    public init(data: Data?, headers: [String: Any]? = nil) {
        self.data = data
        self.headers = headers
    }
    
    public var description: String {
        return "Response Headers: \(headers ?? [:])\nResponse Data:\n\(data?.json ?? [:])\n"
    }
}
