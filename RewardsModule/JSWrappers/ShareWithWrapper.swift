//
//  ShareWithWrapper.swift
//  RewardsModule
//
//  Created by Konstantin on 2/11/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Social

class ShareWithWrapper : JsProtocolWithResponse {
    override func handleEvent(widget: RewardsModule, data: AnyObject, responseCallback: ResponseCallback) {
        let json = JSON(data);
        let appId = json["app"]["id"].string;
        let data = json["data"].stringValue;
        
        if (!appIsInstalled(appId, widget)) {
            return;
        }
        
        
        if (["facebook", "twitter"].contains(appId)) {
            let controller = SLComposeViewController(forServiceType: json["app"]["iosId"].string);
        
            controller?.setInitialText(data);
        
            widget.parentController.present(controller!, animated: true, completion: nil);
        } else {
            guard let params = data.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
                print("shareWithWrapper: incorrect data provided.");

                return;
            };
            
            if (appId == "telegram") {
                openUrl(url: URL(string: "tg://msg?text=\(params)"));
            } else if (appId == "instagram") {
                Helpers.showAlert(controller: widget.parentController,
                                  title: "Message",
                                  message: "The link was copied to the clipboard. To get a reward, send it to any user.",
                                  clickHandler: { _ in
                                    UIPasteboard.general.string = data;
                                    self.openUrl(url: URL(string: "https://www.instagram.com/"));
                });
            }
        }
        
        responseCallback?(nil);
    }
    
    private func openUrl(url: URL?) {
        if (url != nil) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil);
            } else {
                UIApplication.shared.openURL(url!);
            };
        }
    }
    
    private func appIsInstalled(_ appId: String?, _ widget: RewardsModule) -> Bool {
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
            Helpers.showAlert(controller: widget.parentController,
                              title: "Message",
                              message: "You do not have this application. Download it in App Store to share our url.");
        }
        
        return true;
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
