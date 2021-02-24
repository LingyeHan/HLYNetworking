//
//  Foundation+Extension.swift
//  HLYNetworking
//
//  Created by Lingye Han on 2021/2/20.
//

import Foundation

extension Bundle {
    
    public var osName: String {
        #if os(iOS)
        return "iOS"
        #elseif os(watchOS)
        return "watchOS"
        #elseif os(tvOS)
        return "tvOS"
        #elseif os(macOS)
        return "macOS"
        #elseif os(Linux)
        return "Linux"
        #else
        return "Unknown"
        #endif
    }
    
    public var osVersion: String {
        let v = ProcessInfo.processInfo.operatingSystemVersion
        return "\(v.majorVersion).\(v.minorVersion).\(v.patchVersion)"
    }

    public var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    public var appName: String {
        return infoDictionary?[kCFBundleExecutableKey as String] as? String ?? ""
    }
    
    //http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    //"User-Agent" = "YourAppName/1.0.0 (iPhone; iOS 12.1; Scale/3.00)";
    public var userAgent: String {
        #if os(iOS)
        return "\(appName)/\(appVersion) (\(UIDevice.current.model); \(osName) \(osVersion); Scale/\(UIScreen.main.scale))"
        #elseif os(watchOS)
        return "\(appName)/\(appVersion) (\(WKInterfaceDevice.current().model); \(osName) \(osVersion); Scale/\(WKInterfaceDevice.current().screenScale))"
        #endif
    }
}

public extension Data {

    var string: String? {
        return String(data: self, encoding: .utf8)
    }

    var json: [String: Any] {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.mutableLeaves)
            return (jsonObject as? [String : Any]) ?? [:]
        } catch {
            print(error)
        }
        return [:]
    }

    var jsonArray: [[String: Any]]? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.mutableLeaves)
            return (jsonObject as? [[String: Any]])
        } catch {
            print(error)
        }
        return nil
    }
}
