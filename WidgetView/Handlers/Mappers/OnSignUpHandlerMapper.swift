//
//  OnSignUpHandlerMapper.swift
//  WidgetView
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation
import WebViewJavascriptBridge
import SwiftyJSON

class OnSignUpHandlerMapper {
    let handler: OnSignUpHandler;
    
    init(_ handler: @escaping OnSignUpHandler) {
        self.handler = handler;
    }
    
    func map() -> WVJBHandler {
        return { (data, responseCallback) in
            let json = JSON(arrayLiteral: data!);
        
            self.handler(
                json["email"].stringValue,
                json["token"].stringValue,
                json["password"].stringValue,
                Helpers.prepareExtras(json)
            );
            
            if let callback = responseCallback {
                callback(nil);
            }
        }
    }
}
