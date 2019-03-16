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
        let data = json["data"].stringValue;
        
        if (!appIsInstalled(appId, widget)) {
            return;
        }
        
        
        if (["facebook", "twitter"].contains(appId)) {
            let controller = SLComposeViewController(forServiceType: json["app"]["iosId"].string);
        
            controller?.setInitialText(data);
        
            widget.parentController!.present(controller!, animated: true, completion: nil);
        } else {
            var url: URL? = nil;
            
            guard let params = data.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
                print("shareWithWrapper: incorrect data provided.");

                return;
            };
            
            if (appId == "telegram") {
                url = URL(string: "tg://msg?text=\(params)");
            } else if (appId == "instagram") {
                url = URL(string: "instagram://msg?text=\(params)");
                
                UIPasteboard.general.string = data;
            }
            
            if (url != nil) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil);
                } else {
                    UIApplication.shared.openURL(url!);
                };
            }
        }
        
        responseCallback?(nil);
    }
    
    private func appIsInstalled(_ appId: String?, _ widget: CerebellumWidget) -> Bool {
        var url = "";
        
        switch appId {
        case "telegram":
            url = "tg";
        case "instagram":
            url = "instagram";
        case "facebook":
            url = "fb";
        case "twitter":
            url = "twitter";
        default:
            return false;
        }
        
        if (!UIApplication.shared.canOpenURL(URL(string: "\(url)://app")!)) {
            let alert = UIAlertController(title: "Message", message: "You do not have this application. Download it in App Store to share our url.", preferredStyle: UIAlertController.Style.alert);
            
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil));
            
            widget.parentController!.present(alert, animated: true, completion: nil);
        }
        
        return true;
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
