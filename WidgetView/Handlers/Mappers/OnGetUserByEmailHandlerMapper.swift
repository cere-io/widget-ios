//
//  OnGetUserByEmailHandlerMapper.swift
//  WidgetView
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation
import WebViewJavascriptBridge

class OnGetUserByEmailHandlerMapper {
    let handler: OnGetUserByEmailHandler
    
    init(_ handler: @escaping OnGetUserByEmailHandler) {
        self.handler = handler;
    }
    
    func map() -> WVJBHandler {
        return { (email, responseCallback) in
            let handlerCallback: GetUserByEmailCallback = { (exists) in
                if let callback = responseCallback {
                    callback(exists.description);
                }
            };
            
            self.handler(email as! String, handlerCallback);
        }
    }
}
