//
// CerebellumWidget.swift
// CerebellumWidget
//
//  Created by Konstantin on 1/31/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import WebViewJavascriptBridge

public class CerebellumWidget {
    var webView: WKWebView?;
    var bridge: WebViewJavascriptBridge?;
    var parentController: UIViewController?;
    var onInitializationFinishedHandler: OnInitializationFinishedHandler?;

    private var env: Environment = Environment.PRODUCTION;
    private var mode: WidgetMode = WidgetMode.REWARDS;
    private var appId: String = "";
    private var userId: String = "";
    private var sections: [String] = [];
    private var widgetInitialized = false;
    private var handlerQueue: [()->Void] = [];
    
    public var defaultFrame: CGRect?;
    public var frameGapFactor: CGFloat = 0.05; // Should be between 0 .. 0.5.

    public init() {}
    
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
    
    public func show() {
        self.queueHandler({() in
            self.setView(visible: true);
            self.executeJS(method: "__showOnNative");
        });
    }
    
    public func hide() {
        self.queueHandler({() in
            self.setView(visible: false);
        });
    }

    public func sendDataToField(fieldName: String, value: String) {
        self.queueHandler({() in
            self.executeJS(method: "sendToField", withParams: "'\(fieldName)', '\(value)'");
        });
    }

    public func setMode(mode: WidgetMode) {
        self.mode = mode;
        
        self.queueHandler({() in
            self.executeJS(method: "setMode", withParams: "'\(String(describing: self.mode).lowercased())'");
        });
    }
    
    public func setUserData(data: String) {
        self.queueHandler({() in
            self.executeJS(method: "setUserData", withParams: data);
        });
    }
    
    public func collapse() {
        self.queueHandler({() in
            self.setView(visible: false);
        });
    }
    
    public func expand() {
        self.queueHandler({() in
            let s = UIScreen.main.bounds;

            self.webView?.frame = s;
        });
    }

    public func restore() {
        self.queueHandler({() in
            self.webView?.frame = self.defaultFrame!;
        });
    }
    
    public func resize(width: CGFloat, height: CGFloat) {
        self.webView?.frame.size.height = height;
        self.webView?.frame.size.width = width;
    }
    
    public func logout() {
        self.queueHandler({() in
            self.bridge?.callHandler("logout");
            self.loadContent();
        });
    }
    
    public func onInitializationFinished(_ handler: @escaping OnInitializationFinishedHandler) -> CerebellumWidget {
        self.onInitializationFinishedHandler = handler;
        
        return self;
    }
    
    public func onHide(_ handler: @escaping OnHideHandler) -> CerebellumWidget {
        self.queueHandler({() in
            self.bridge?.registerHandler("onHide",
                                         handler: OnHideHandlerMapper(handler).map());
        });

        return self;
    }
    
    public func onSignUp(_ handler: @escaping OnSignUpHandler) -> CerebellumWidget {
        self.queueHandler({() in
            self.bridge?.registerHandler("onSignUp",
                                         handler: OnSignUpHandlerMapper(handler).map());
        });
        
        return self;
    }
    
    public func onSignIn(_ handler: @escaping OnSignInHandler) -> CerebellumWidget {
        self.queueHandler({() in
            self.bridge?.registerHandler("onSignIn",
                                     handler: OnSignInHandlerMapper(handler).map());
        });
        
        return self;
    }
    
    public func onProcessNonFungibleReward(_ handler: @escaping OnProcessNonFungibleRewardHandler) -> CerebellumWidget {
        self.queueHandler({() in
            self.bridge?.registerHandler("onProcessNonFungibleReward",
                                         handler: OnProcessNonFungibleRewardHandlerMapper(handler).map());
        });
        
        return self;
    }
    
    public func onGetClaimedRewards(_ handler: @escaping OnGetClaimedRewardsHandler) -> CerebellumWidget {
        self.queueHandler({() in
            self.bridge?.registerHandler("onGetClaimedRewards",
                                         handler: OnGetClaimedRewardsHandlerMapper(handler).map());
        });
        
        return self;
    }
    
    public func onGetUserByEmail(_ handler: @escaping OnGetUserByEmailHandler) -> CerebellumWidget {
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
        self.webView!.frame = visible ? self.defaultFrame! : .zero;
    }
    
    func executeJS(method: String, withParams: String = "") {
        let js = "window.CRBWidget." + method + "(" + withParams + ");";
        
        self.bridge?._evaluateJavascript(js);
    }
    
    func load() {
        initDefaultSize();
        createViewAndAddAsSubview();
        attachBridge();
        loadContent();
    }
    
    func createViewAndAddAsSubview() {
        let configuration = WKWebViewConfiguration();
        
        self.webView = WKWebView(frame: .zero, configuration: configuration);
        self.parentController!.view.addSubview(self.webView!);
    }
    
    func initDefaultSize() {
        let s = UIScreen.main.bounds;
        
        self.defaultFrame = CGRect(
            x: s.minX + s.width * frameGapFactor,
            y: s.minY + s.height * frameGapFactor,
            width: s.width - 2 * s.width * frameGapFactor,
            height: s.height - 2 * s.height * frameGapFactor);
    }
    
    func loadContent() {
        do {
            let template = try loadHtmlTemplate();
            let content = insertParametersToTemplate(
                template,
                widgetUrl: env.sdkURL + Environment.bundleJSPath,
                userId: self.userId,
                appId: self.appId,
                env: self.env.name,
                mode: String(describing: self.mode).lowercased(),
                sections: self.sections.joined(separator: ","));
            
            self.webView!.loadHTMLString(content, baseURL: URL(string: env.widgetURL)!);
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
}
