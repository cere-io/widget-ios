//
//  GetNativeStorageItemWrapper.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

class GetNativeStorageItemWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: WidgetViewController, data: AnyObject, responseCallback: ResponseCallback) {
        if let bodyObj = data as? [AnyObject] {
            guard let key = bodyObj[0] as? String,
                  let value = KeychainService().getValue(byKey: key) else {
                    responseCallback?("~<Native Storage Error>~");
                    
                    return;
            }
            
            responseCallback?(value)
        }
    }
}
