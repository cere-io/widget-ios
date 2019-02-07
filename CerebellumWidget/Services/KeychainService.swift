//
//  KeychainService.swift
// CerebellumWidget
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation
import KeychainAccess
import WebViewJavascriptBridge

final class KeychainService {
    static let defaultPrefix = "CRBWidget-"
    
    fileprivate let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? defaultPrefix)
    
    func set(_ value: String?, for key: String) {
        keychain[KeychainService.defaultPrefix + key] = value
    }
    
    func getValue(byKey key: String) -> String? {
        do {
            let value = try keychain.get(KeychainService.defaultPrefix + key)
            return value
        } catch let error {
            print("ERROR while reading k-value: \(error)")
        }
        return nil
    }
    
    func delete(byKey key: String) {
        keychain[key] = nil
    }
}
