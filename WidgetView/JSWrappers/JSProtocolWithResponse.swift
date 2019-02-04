//
//  JSProtocolWithResponse.swift
//  WidgetView
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

class JsProtocolWithResponse {
    typealias ResponseCallback = ((Any?) -> Swift.Void)?
    
    func handleEvent(widget: WidgetViewController, data: AnyObject, responseCallback: ResponseCallback){}
}
