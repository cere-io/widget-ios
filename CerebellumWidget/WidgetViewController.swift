//
// CerebellumWidgetController.swift
// CerebellumWidget
//
//  Created by Konstantin on 1/31/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import WebViewJavascriptBridge

public class WidgetViewController: UIViewController {
    var webView: WKWebView?;
    var bridge: WebViewJavascriptBridge?;
    var parentController: UIViewController?;

    private var env: Environment = Environment.PRODUCTION;
    private var mode: WidgetMode = WidgetMode.REWARDS;
    private var appId: String = "";
    private var userId: String = "";
    private var sections: [String] = [];
    private var widgetInitialized = false;
    private var handlerQueue: [()->Void] = [];
    
    public var defaultFrame: CGRect?;
    public var frameGapFactor: CGFloat = 0.05; // Should be between 0 .. 0.5.
    
    public override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    public override func loadView() {
        super.loadView();
    }
    
    public func initAndLoad(parentController: UIViewController, userId: String, appId: String, sections: [String], env: Environment = Environment.PRODUCTION) {
        if (widgetInitialized) {
            return;
        }

        self.parentController = parentController;
        self.userId = userId;
        self.appId = appId;
        self.sections = sections;
        self.env = env;
        
        load();
    }
    
    public func show() -> WidgetViewController {
        self.queueHandler({() in
            self.setView(visible: true);
        });
        
        return self;
    }
    
    public func hide() -> WidgetViewController {
        self.queueHandler({() in
            self.setView(visible: false);
        });
    
        return self;
    }

    public func sendDataToField(fieldName: String, value: String) -> WidgetViewController {
        self.queueHandler({() in
            self.executeJS(method: "sendToField", withParams: "'\(fieldName)', '\(value)'");
        });
    
        return self;
    }

    public func setMode(mode: WidgetMode) -> WidgetViewController {
        self.mode = mode;
        
        self.queueHandler({() in
            self.executeJS(method: "setMode", withParams: "'\(String(describing: self.mode).lowercased())'");
        });
    
        return self;
    }
    
    public func setUserData(data: String) -> WidgetViewController {
        self.queueHandler({() in
            self.executeJS(method: "setUserData", withParams: data);
        });
    
        return self;
    }
    
    public func collapse() -> WidgetViewController {
        self.queueHandler({() in
            self.setView(visible: false);
        });
        
        return self;
    }
    
    public func expand() -> WidgetViewController {
        self.queueHandler({() in
            let s = UIScreen.main.bounds;

            self.webView?.frame = s;
        });
        
        return self;
    }

    public func restore() -> WidgetViewController {
        self.queueHandler({() in
            self.webView?.frame = self.defaultFrame!;
        });
        
        return self;
    }
    
    public func resize(width: CGFloat, height: CGFloat) {
        self.webView?.frame.size.height = height;
        self.webView?.frame.size.width = width;
    }
    
    public func logout() {
        self.queueHandler({() in
            self.bridge?.callHandler("logout");
        });
    }
    
    public func onHide(_ handler: @escaping OnHideHandler) -> WidgetViewController {
        self.queueHandler({() in
            self.bridge?.registerHandler("onHide",
                                         handler: OnHideHandlerMapper(handler).map());
        });

        return self;
    }
    
    public func onSignUp(_ handler: @escaping OnSignUpHandler) -> WidgetViewController {
        self.queueHandler({() in
            self.bridge?.registerHandler("onSignUp",
                                         handler: OnSignUpHandlerMapper(handler).map());
        });
        
        return self;
    }
    
    public func onSignIn(_ handler: @escaping OnSignInHandler) -> WidgetViewController {
        self.queueHandler({() in
            self.bridge?.registerHandler("onSignIn",
                                     handler: OnSignInHandlerMapper(handler).map());
        });
        
        return self;
    }
    
    public func onProcessNonFungibleReward(_ handler: @escaping OnProcessNonFungibleRewardHandler) -> WidgetViewController {
        self.queueHandler({() in
            self.bridge?.registerHandler("onProcessNonFungibleReward",
                                         handler: OnProcessNonFungibleRewardHandlerMapper(handler).map());
        });
        
        return self;
    }
    
    public func onGetClaimedRewards(_ handler: @escaping OnGetClaimedRewardsHandler) -> WidgetViewController {
        self.queueHandler({() in
            self.bridge?.registerHandler("onGetClaimedRewards",
                                         handler: OnGetClaimedRewardsHandlerMapper(handler).map());
        });
        
        return self;
    }
    
    
    public func onGetUserByEmail(_ handler: @escaping OnGetUserByEmailHandler) -> WidgetViewController {
        self.queueHandler({() in
            self.bridge?.registerHandler("onGetUserByEmail",
                                         handler: OnGetUserByEmailHandlerMapper(handler).map());
        });
        
        return self;
    }
    
    func queueHandler(_ handler: @escaping () -> Void) {
        if (widgetInitialized) {
            handler();
        } else {
            handlerQueue.append(handler);
        }
    }
    
    func setView(visible: Bool) {
        if (visible) {
            self.parentController!.addChildViewController(self);
            self.beginAppearanceTransition(true, animated: true)
            self.parentController!.view.addSubview(self.webView!);
            self.endAppearanceTransition();
            
            self.didMove(toParentViewController: self);
        } else {
            self.willMove(toParentViewController: nil);
            self.view.removeFromSuperview();
            self.removeFromParentViewController();
        }
    }
    
    func executeJS(method: String, withParams: String = "") {
        let js = "window.CRBWidget." + method + "(" + withParams + ");";
        
        self.bridge?._evaluateJavascript(js);
    }
    
    func load() {
        let configuration = WKWebViewConfiguration();
        let s = UIScreen.main.bounds;
        
        defaultFrame = CGRect(x: s.minX + s.width * frameGapFactor,
                              y: s.minY + s.height * frameGapFactor,
                              width: s.width - 2 * s.width * frameGapFactor,
                              height: s.height - 2 * s.height * frameGapFactor);
        
        self.webView = WKWebView(frame: defaultFrame!, configuration: configuration);
        self.view = self.webView;
        
        attachBridge();
        
        do {
            let template = try loadHtmlTemplate();
            let content = insertParametersToTemplate(template,
                                                     widgetUrl: env.sdkURL + Environment.bundleJSPath,
                                                     userId: self.userId,
                                                     appId: self.appId,
                                                     env: self.env.name,
                                                     mode: String(describing: self.mode).lowercased(),
                                                     sections: self.sections.joined(separator: ", "));
            self.webView!.loadHTMLString(content, baseURL: URL(string: env.sdkURL)!);
        } catch {
            print("Can not initialize widget");
        }
    }
    
    func attachBridge() {
        self.bridge = WebViewJavascriptBridge(forWebView: webView);
        
        WebViewJavascriptBridge.enableLogging();
        
        for jsCallback in JSCallbackList {
            bridge!.registerHandler(jsCallback.key, handler: { (data, responseCallback) in
                
                jsCallback.value.handleEvent(widget: self, data: data as AnyObject, responseCallback: responseCallback);
            })
        }
    }
    
    func loadHtmlTemplate() throws -> String {
        let path = Bundle(for: type(of: self)).path(forResource: "index", ofType: "html");
        let content = try String(contentsOfFile: path!,
                             encoding: String.Encoding.utf8);
        
        return content;
    }
    
    func insertParametersToTemplate(_ template: String,
                                    widgetUrl: String,
                                    userId: String,
                                    appId: String,
                                    env: String,
                                    mode: String,
                                    sections: String) -> String {
        return template
            .replacingOccurrences(of: "::widgetUrl::", with: widgetUrl)
            .replacingOccurrences(of: "::userId::", with: userId)
            .replacingOccurrences(of: "::appId::", with: appId)
            .replacingOccurrences(of: "::env::", with: env)
            .replacingOccurrences(of: "::mode::", with: mode)
            .replacingOccurrences(of: "::sections::", with: sections);
    }
    
    func setInitialized() {
        if (self.widgetInitialized) {
            return;
        }
        
        self.widgetInitialized = true;
        
        for handler in self.handlerQueue {
            handler();
        }
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}
