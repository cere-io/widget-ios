//
//  InitializedWrapper.swift
// RewardsModule
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

class InitializedWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: RewardsModule, data: AnyObject, responseCallback: ResponseCallback) {
        let json = JSON(data);
        let left = json["left"].float;
        let top = json["top"].float;
        let width = json["width"].float;
        let height = json["height"].float;
        
        widget.setInitialized();
        
        if (left != nil && top != nil && width != nil && height != nil) {
            widget.resize(left: CGFloat(left!),
                          top: CGFloat(top!),
                          width: CGFloat(width!),
                          height: CGFloat(height!));
        }
        
        widget.onInitializationFinishedHandler?();
        
        responseCallback?(nil);
    }
}
