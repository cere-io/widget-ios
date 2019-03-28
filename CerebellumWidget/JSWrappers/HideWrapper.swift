//
//  HideWrapper.swift
// CerebellumWidget
//
//  Created by Konstantin on 2/6/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

class HideWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: CerebellumWidget, data: AnyObject, responseCallback: ResponseCallback) {
        widget.hide();
        
        widget.onHideHandler?();
        
        responseCallback?(nil);
    }
}
