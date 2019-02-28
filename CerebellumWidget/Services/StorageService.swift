//
//  StorageService.swift
// CerebellumWidget
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation
import WebViewJavascriptBridge

final class StorageService {
    static let defaultPrefix = "CRBWidget-"
    let customPrefix: String;
    
    init(_ customPrefix: String) {
        self.customPrefix = customPrefix;
    }
    
    func set(_ value: String?, for key: String) {
        UserDefaults.standard.set(value, forKey: buildKey(key));
    }
    
    func getValue(byKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: buildKey(key));
    }
    
    private func buildKey(_ key: String) -> String {
        return "\(StorageService.defaultPrefix).\(customPrefix).\(key)";
    }
}
