//
//  OnSignInHandlerMapper.swift
//  WidgetView
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation
import WebViewJavascriptBridge
import SwiftyJSON

class OnSignInHandlerMapper {
    let handler: OnSignInHandler;
    
    init(_ handler: @escaping OnSignInHandler) {
        self.handler = handler;
    }
    
    func map() -> WVJBHandler {
        return { (data, responseCallback) in
            let json = JSON(arrayLiteral: data!);
            
            self.handler(
                json["email"].stringValue,
                json["token"].stringValue,
                Helpers.prepareExtras(json)
            );
            
            if let callback = responseCallback {
                callback(nil);
            }
        }
    }
}
