//
//  OnSignUpHandlerMapper.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
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
                json[0]["email"].stringValue,
                json[0]["token"].stringValue,
                json[0]["password"].stringValue,
                Helpers.prepareExtras(json)
            );
            
            if let callback = responseCallback {
                callback(nil);
            }
        }
    }
}
