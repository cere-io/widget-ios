//
//  ShareWrapper.swift
//  RewardsModule
//
//  Created by Konstantin on 2/10/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation

class ShareWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: RewardsModule, data: AnyObject, responseCallback: ResponseCallback) {
        
        let activityController = UIActivityViewController.init(activityItems: NSMutableArray.init(object: data) as! [Any], applicationActivities: nil);
        
        widget.parentController.present(activityController, animated: true, completion: nil);
        
        responseCallback?(nil);
    }
}
