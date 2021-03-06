//
//  SetNativeStorageItemWrapper.swift
// RewardsModule
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation

class SetNativeStorageItemWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: RewardsModule, data: AnyObject, responseCallback: ResponseCallback) {
        if let bodyObj = data as? [AnyObject] {
            guard let key = bodyObj[0] as? String,
                  let value = bodyObj[1] as? String else {
                
                    responseCallback?(false);
                    return;
            }

            StorageService(widget.env.name).set(value, for: key);
            
            print("SetNativeStorageItemWrapper: key=\(key) value=\(value)");
        }
        
        responseCallback?(true);
    }
}
