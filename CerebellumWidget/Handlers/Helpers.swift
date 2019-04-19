//
//  Helpers.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

class Helpers {
    static func prepareExtras(_ json: JSON) -> [String:String] {
        var result: [String: String] = [:];
        
        if (json[0]["extras"].exists()) {
            for (key, value) in json[0]["extras"] {
                result[key] = value.stringValue;
            }
        }
        
        return result;
    }
}
