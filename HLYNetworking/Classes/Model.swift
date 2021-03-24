//
//  Model.swift
//  HLYNetworking
//
//  Created by Lingye Han on 2021/2/20.
//

import Foundation

public protocol Model: Codable, Equatable {
    
}

enum DateType: String {
    case iso8601x = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    case java = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
    case javaSimple = "yyyy-MM-dd HH:mm:ss Z"
    case simple = "yyyy-MM-dd"
    
    static let formats: [DateType] = [iso8601x, iso8601, java, javaSimple, simple]
}
open class JSONCoder {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    public static var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }()
    
    public static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            
            if let dateTimestamp = try? container.decode(TimeInterval.self) {
                let currentTimestamp = Date().timeIntervalSince1970
                if dateTimestamp/currentTimestamp > 500 {
                    return Date(timeIntervalSince1970: dateTimestamp/1000)
                } else {
                    return Date(timeIntervalSince1970: dateTimestamp)
                }
            }
            
            let dateString = try container.decode(String.self)
            for format in DateType.formats {
                formatter.dateFormat = format.rawValue
                if let date = formatter.date(from: dateString) {
                    return date
                }
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        }
        return decoder
    }()
    
    public static func decode<T: Model>(data: Data) throws -> T {
        return try decoder.decode(T.self, from: data)
    }
    
    public static func decode<T: Model>(JSONObject obj: Any) throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: obj, options: [])
        let model = try decoder.decode(T.self, from: jsonData)
        return model
    }
}
