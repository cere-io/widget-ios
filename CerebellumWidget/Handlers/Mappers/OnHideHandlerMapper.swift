//
//  OnHideHandlerMapper.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
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
