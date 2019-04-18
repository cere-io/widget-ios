//
//  JSProtocolWithResponse.swift
// CerebellumWidget
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation

class JsProtocolWithResponse {
    typealias ResponseCallback = ((Any?) -> Swift.Void)?
    
    func handleEvent(widget: CerebellumWidget, data: AnyObject, responseCallback: ResponseCallback){}
}
