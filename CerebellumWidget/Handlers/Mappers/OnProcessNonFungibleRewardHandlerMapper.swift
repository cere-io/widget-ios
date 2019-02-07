//
//  OnProcessNonFungibleRewardHandlerMapper.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation
import WebViewJavascriptBridge

class OnProcessNonFungibleRewardHandlerMapper {
    let handler: OnProcessNonFungibleRewardHandler;
    
    init(_ handler: @escaping OnProcessNonFungibleRewardHandler) {
        self.handler = handler;
    }
    
    func map() -> WVJBHandler {
        return { (data, responseCallback) in
            self.handler(data as! String);
            
            if let callback = responseCallback {
                callback(nil);
            }
        }
    }
}
