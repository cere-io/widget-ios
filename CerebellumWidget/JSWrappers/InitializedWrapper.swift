//
//  InitializedWrapper.swift
// CerebellumWidget
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class InitializedWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: CerebellumWidget, data: AnyObject, responseCallback: ResponseCallback) {
        let json = JSON(data);
        
        widget.setInitialized();
        widget.onInitializationFinishedHandler?(Bool(json.stringValue) ?? false);
        
        responseCallback?(nil);
    }
}
