//
//  OnHideHandlerMapper.swift
//  RewardsModule
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation
import WebViewJavascriptBridge

class OnHideHandlerMapper {
    let handler: OnHideHandler;
    
    init(_ handler: @escaping OnHideHandler) {
        self.handler = handler;
    }
    
    func map() -> WVJBHandler {
        return { (data, responseCallback) in
            self.handler();
            
            if let callback = responseCallback {
                callback(nil);
            }
        }
    }
}
