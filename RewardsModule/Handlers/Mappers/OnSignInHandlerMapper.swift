//
//  OnSignInHandlerMapper.swift
//  RewardsModule
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
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
                json[0]["email"].stringValue,
                json[0]["token"].stringValue,
                Helpers.prepareExtras(json)
            );
            
            if let callback = responseCallback {
                callback(nil);
            }
        }
    }
}
