//
//  GetReferralsInfoWrapper.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/18/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation

class GetReferralsInfoWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: CerebellumWidget, data: AnyObject, responseCallback: ResponseCallback) {
        
        responseCallback?(nil);
    }
}
