//
//  SetNativeStorageItemWrapper.swift
// CerebellumWidget
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

class SetNativeStorageItemWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: WidgetViewController, data: AnyObject, responseCallback: ResponseCallback) {
        if let bodyObj = data as? [AnyObject] {
            guard let key = bodyObj[0] as? String,
                  let value = bodyObj[1] as? String else {
                
                    responseCallback?(false);
                    return;
            }

            KeychainService().set(value, for: key);
            
            print("SetNativeStorageItemWrapper: key=\(key) value=\(value)");
        }
        
        responseCallback?(true);
    }
}
