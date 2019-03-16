//
//  ShowNativeMessageWrapper.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/18/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

class ShowNativeMessageWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: CerebellumWidget, data: AnyObject, responseCallback: ResponseCallback) {
        
        let message: String? = data as? String;
        
        if (message != nil) {
            let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert);
        
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil));
            
            widget.parentController!.present(alert, animated: true, completion: nil);
        }
        
        responseCallback?(nil);
    }
}
