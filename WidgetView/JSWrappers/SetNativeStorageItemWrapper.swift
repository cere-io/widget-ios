//
//  SetNativeStorageItemWrapper.swift
//  WidgetView
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

class SetNativeStorageItemWrapper : JsProtocolWithResponse {
    override func handleEvent(_ body: AnyObject, responseCallback: ResponseCallback) {
        if let bodyObj = body as? [AnyObject] {
            guard let key = bodyObj[0] as? String,
                  let value = bodyObj[1] as? String else {
                    return;
            }

            KeychainService().set(value, for: key);
            
            print("SetNativeStorageItemWrapper: key=\(key) value=\(value)");
        }
    }
}
