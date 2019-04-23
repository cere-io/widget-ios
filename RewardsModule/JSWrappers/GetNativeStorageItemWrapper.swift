//
//  GetNativeStorageItemWrapper.swift
//  RewardsModule
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation

class GetNativeStorageItemWrapper : JsProtocolWithResponse {
    private let storageErrorString = "~<Native Storage Error>~";

    override func handleEvent(widget: RewardsModule, data: AnyObject, responseCallback: ResponseCallback) {
        if let bodyObj = data as? [AnyObject] {
            guard let key = bodyObj[0] as? String else {
                responseCallback?(storageErrorString);
                
                return;
            }
            let value = StorageService(widget.env.name).getValue(byKey: key);
            
            responseCallback?(value);
        }
    }
}
