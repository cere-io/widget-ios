//
//  ShowWrapper.swift
// RewardsModule
//
//  Created by Konstantin on 2/6/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

class ShowWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: RewardsModule, data: AnyObject, responseCallback: ResponseCallback) {
        let json = JSON(data);
        
        widget.show(placement: json["placement"].stringValue);
        
        responseCallback?(nil);
    }
}
