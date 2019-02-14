//
//  OnGetClaimedRewardsHandlerMapper.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
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
                        "additionalInfo": [
                            "Code: \(item.additionalInfo.code.description)",
                            "Order ID: \(item.additionalInfo.orderId.description)",
                            "Created: \(item.additionalInfo.createdAt.description)",
                        ] as AnyObject,
                    ]);
                }
                
                responseCallback?(JSON(list).description);
            };
            
            self.handler(handlerCallback);
        }
    }
}
