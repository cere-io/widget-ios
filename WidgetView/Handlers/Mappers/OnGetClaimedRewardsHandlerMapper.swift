//
//  OnGetClaimedRewardsHandlerMapper.swift
//  WidgetView
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation
import WebViewJavascriptBridge

class OnGetClaimedRewardsHandlerMapper {
    let handler: OnGetClaimedRewardsHandler
    
    init(_ handler: @escaping OnGetClaimedRewardsHandler) {
        self.handler = handler;
    }

    func map() -> WVJBHandler {
        return { (data, responseCallback) in
            let handlerCallback: GetClaimedRewardsCallback = {(resultList) in
                // resultList is json string for now.
                
                if let callback = responseCallback {
                    if (resultList == nil) {
                        callback("[]");
                    } else {
                        callback(resultList);
                    }
                }
            };
            
            self.handler(handlerCallback);
        }
    }
}
