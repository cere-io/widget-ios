//
//  ShowWrapper.swift
// CerebellumWidget
//
//  Created by Konstantin on 2/6/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class ShowWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: CerebellumWidget, data: AnyObject, responseCallback: ResponseCallback) {
        let json = JSON(data);
        
        widget.show(placement: json["placement"].stringValue);
        
        responseCallback?(nil);
    }
}
