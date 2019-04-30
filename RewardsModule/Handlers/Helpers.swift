//
//  Helpers.swift
//  RewardsModule
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
    
    static func showAlert(controller: UIViewController, title: String, message: String, button: String = "Close",
                          clickHandler: @escaping (UIAlertAction) -> Void = {_ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
        
        alert.addAction(UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: clickHandler));
        
        controller.present(alert, animated: true, completion: nil);
    }
}
