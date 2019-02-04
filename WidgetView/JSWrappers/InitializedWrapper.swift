//
//  InitializedWrapper.swift
//  WidgetView
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

class InitializedWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: WidgetViewController, data: AnyObject, responseCallback: ResponseCallback) {
        widget.setInitialized();
            
        responseCallback?(nil);
    }
}
