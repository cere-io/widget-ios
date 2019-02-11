//
//  ShareWithWrapper.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/11/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation
import SwiftyJSON
import Social

class ShareWithWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: CerebellumWidget, data: AnyObject, responseCallback: ResponseCallback) {
        let json = JSON(data);
        let appId = json["app"]["id"].string;
        if (["facebook", "twitter"].contains(appId)) {
            let controller = SLComposeViewController(forServiceType: json["app"]["iosId"].string);
        
            controller?.setInitialText(json["data"].string);
        
            widget.parentController!.present(controller!, animated: true, completion: nil);
        } else {
            var url: URL? = nil;
            
            if (appId == "telegram") {
                url = URL(string: "tg://msg?text=\(json["data"].string!)");
            } else if (appId == "instagram") {
                url = URL(string: "instagram://msg?text=\(json["data"].string!)");
            }
            
            if (url != nil /* && UIApplication.shared.canOpenURL(url!) */) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil);
                } else {
                    UIApplication.shared.openURL(url!);
                };
            }
        }
        
        responseCallback?(nil);
    }
}
