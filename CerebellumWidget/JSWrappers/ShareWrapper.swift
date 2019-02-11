//
//  ShareWrapper.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/10/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

class ShareWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: WidgetViewController, data: AnyObject, responseCallback: ResponseCallback) {
        
        let activityController = UIActivityViewController.init(activityItems: NSMutableArray.init(object: data) as! [Any], applicationActivities: nil);
        
        widget.parent?.present(activityController, animated: true, completion: nil);
        
        responseCallback?(nil);
    }
}
