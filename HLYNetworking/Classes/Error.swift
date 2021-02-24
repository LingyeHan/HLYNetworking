//
//  Error.swift
//  HLYNetworking
//
//  Created by Lingye Han on 2021/2/23.
//

import Foundation

public let kRequestErrorDomain: String = "com.hly.networking.request.error"

public enum StatusCode {
    case informational, successful, redirection, clientError, serverError, cancelled, unknown
}
public extension Int {

    var statusCode: StatusCode {
        switch self {
        case URLError.cancelled.rawValue:
            return .cancelled
        case 100 ..< 200:
            return .informational
        case 200 ..< 300:
            return .successful
        case 300 ..< 400:
            return .redirection
        case 400 ..< 500:
            return .clientError
        case 500 ..< 600:
            return .serverError
        default:
            return .unknown
        }
    }
}
