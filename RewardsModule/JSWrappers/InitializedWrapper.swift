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
        let left = json["left"].floatValue;
        let top = json["top"].floatValue;
        let width = json["width"].floatValue;
        let height = json["height"].floatValue;
        
        widget.setInitialized();
        
        if (width != 0 && height != 0) {
            widget.resize(left: CGFloat(left),
                          top: CGFloat(top),
                          width: CGFloat(width),
                          height: CGFloat(height));
        }
        
        widget.onInitializationFinishedHandler?();
        
        responseCallback?(nil);
    }
}
