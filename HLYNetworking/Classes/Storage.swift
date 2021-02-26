//
//  Storage.swift
//  HLYNetworking
//
//  Created by Lingye Han on 2021/2/25.
//

import Foundation

final class Storage {
    
    static let shared = Storage()
    
    private static let Domain = "com.hly.networking.storage"
    
    private let key: String
    
    fileprivate var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    init(name: String = "Default") {
        key = "\(Storage.Domain).\(name)"
    }
    
    func object(forKey key: String) -> Any? {
        return userDefaults.object(forKey: key)
    }
    
    func setObject(_ value: Any?, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func removeObject(forKey defaultName: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    static func clearAll() {
        let userDefaults = UserDefaults.standard
        let keys = userDefaults.dictionaryRepresentation().keys
        let storageKeys = keys.filter { $0.contains(Domain) }
        
        for key in storageKeys {
            userDefaults.removeObject(forKey: key)
        }
    }
}
