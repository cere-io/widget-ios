//
//  HideWrapper.swift
// CerebellumWidget
//
//  Created by Konstantin on 2/6/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

class HideWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: WidgetViewController, data: AnyObject, responseCallback: ResponseCallback) {
        widget.hide();
        
        responseCallback?(nil);
    }
}
