//
//  LogoutWrapper.swift
// RewardsModule
//
//  Created by Konstantin on 2/6/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation

class LogoutWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: RewardsModule, data: AnyObject, responseCallback: ResponseCallback) {
        responseCallback?(nil);
    }
}
