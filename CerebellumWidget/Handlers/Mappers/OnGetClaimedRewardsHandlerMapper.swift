//
//  OnGetClaimedRewardsHandlerMapper.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation
import WebViewJavascriptBridge
import SwiftyJSON

class OnGetClaimedRewardsHandlerMapper {
    let handler: OnGetClaimedRewardsHandler
    
    init(_ handler: @escaping OnGetClaimedRewardsHandler) {
        self.handler = handler;
    }

    func map() -> WVJBHandler {
        return { (data, responseCallback) in
            let handlerCallback: GetClaimedRewardsCallback = {(resultList) in
                // resultList is json string for now.
                
                var list: [[String: AnyObject]] = [];
                
                for item in resultList {
                    list.append([
                        "title": item.title as AnyObject,
                        "img": item.imageUrl as AnyObject,
                        "price": "\(item.price) \(item.currency)" as AnyObject,
                        "redemptionInstructions": "\(item.redemptionInstructions)" as AnyObject,
                        "additionalInfo": item.additionalInfo as AnyObject,
                    ]);
                }
                
                responseCallback?(JSON(list).description);
            };
            
            self.handler(handlerCallback);
        }
    }
}
