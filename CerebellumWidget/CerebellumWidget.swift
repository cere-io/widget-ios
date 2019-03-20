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

/// Class that implements CerebellumWidgetProtocol and provides all the functionality of the widget.
///
public class CerebellumWidget: NSObject, CerebellumWidgetProtocol {
    var webView: WKWebView?;
    var bridge: WebViewJavascriptBridge?;
    var parentController: UIViewController?;
    var onInitializationFinishedHandler: OnInitializationFinishedHandler?;
    var onGetUserByEmailHandler: OnGetUserByEmailHandler?;
    var onSignInHandler: OnSignInHandler?;
    var onSignUpHandler: OnSignUpHandler?;

    internal var env: Environment = Environment.PRODUCTION;
    private var mode: WidgetMode = WidgetMode.REWARDS;
    private var appId: String = "";
    private var userId: String?;
    private var sections: [String] = [];
    private var widgetInitialized = false;
    private var handlerQueue: [()->Void] = [];
    
    /// Stores initial size of the widget. Default value is whole screen size, but frame with width * frameGapFactor and height * frameGapFactor.
    public var defaultFrame: CGRect?;
    
    /// Factor that specifies width of the frame between the widget and screen bounds.
    public var frameGapFactor: CGFloat = 0.05; // Should be between 0 .. 0.5.

    /// Initializes and prepares the widget for usage.
    /// - Parameter: parentController: controller that will host the widget view and is responsible for showing/hiding the widget.
    /// - Parameter: applicationId: identifier of the application from RMS.
    /// - Parameter: userId: (optional) email of user that is using widget. If user is not authorized, this parameter can be omit.
    /// - Parameter: sections: (optional) section name from RMS with rewards. It is used if you need to show widget in
    /// more than one place in your application with different rewards.
    /// - Parameter: env: Environment for running the widget (`PRODUCTION` is default).
    ///
    public func initAndLoad(parentController: UIViewController, applicationId: String, userId: String? = nil, sections: [String] = ["default"], env: Environment = Environment.PRODUCTION) {
        if (widgetInitialized) {
            return;
        }

        self.parentController = parentController;
        self.userId = userId;
        self.appId = applicationId;
        self.sections = sections;
        self.env = env;
        
        load();
        setupDefaultHandlers();
    }

    /// Shows the widget if it is hidden.
    public func show() {
        self.queueHandler({() in
            self.setView(visible: true);
            self.executeJS(method: "__showOnNative");
        });
    }
    
    /// Hides the widget.
    public func hide() {
        self.queueHandler({() in
            self.setView(visible: false);
        });
    }

    /// Autofills specified field with value to reduce amount of questions to user (i.e. `email`).
    public func sendDataToField(fieldName: String, value: String) {
        self.queueHandler({() in
            self.executeJS(method: "sendToField", withParams: "'\(fieldName)', '\(value)'");
        });
    }

    /// Sets the mode to present the widget.
    public func setMode(mode: WidgetMode) {
        self.mode = mode;
        
        self.queueHandler({() in
            self.executeJS(method: "setMode", withParams: "'\(String(describing: self.mode).lowercased())'");
        });
    }
    
    /// Sets additional information to be shown in widget in JSON format. Only `level` and `name` are supported now.
    /// Example:
    /// ```JSON
    ///     {
    ///         userData:
    ///         {
    ///             name: "Junior",
    ///             level: 1,
    ///         }
    ///     }
    public func setUserData(data: String) {
        self.queueHandler({() in
            self.executeJS(method: "setUserData", withParams: data);
        });
    }
    
    /// Minimizes the widget.
    public func collapse() {
        self.queueHandler({() in
            self.setView(visible: false);
        });
    }
    
    /// Expanding the widget view on full screen.
    public func expand() {
        self.queueHandler({() in
            let s = UIScreen.main.bounds;

            self.webView?.frame = s;
        });
    }

    /// Restores size of the widget after expanding.
    public func restore() {
        self.queueHandler({() in
            self.webView?.frame = self.defaultFrame!;
        });
    }
    
    /// Sets custom size for the widget.
    public func resize(width: CGFloat, height: CGFloat) {
        self.webView?.frame.size.height = height;
        self.webView?.frame.size.width = width;
    }
    
    /// Logs out of the widget.
    public func logout() {
        self.queueHandler({() in
            self.bridge?.callHandler("logout");
            //self.loadContent();
        });
    }
    
    /// Sets handler that is called when widget is finished initialization.
    public func onInitializationFinished(_ handler: @escaping OnInitializationFinishedHandler) -> CerebellumWidget {
        self.onInitializationFinishedHandler = handler;
        
        return self;
    }
    
    /// Sets handler that is called on widget closed.
    public func onHide(_ handler: @escaping OnHideHandler) -> CerebellumWidget {
        self.queueHandler({() in
            self.bridge?.registerHandler("onHide",
                                         handler: OnHideHandlerMapper(handler).map());
        });

        return self;
    }
    
    /// Sets handler to be called when user finished sign up flow.
    public func onSignUp(_ handler: @escaping OnSignUpHandler) -> CerebellumWidget {
        self.onSignUpHandler = handler;
        
        return self;
    }
    
    /// Sets handler to be called when user successfully signed in to the widget.
    public func onSignIn(_ handler: @escaping OnSignInHandler) -> CerebellumWidget {
        self.onSignInHandler = handler;
        
        return self;
    }
    
    /// Sets handler to be called when user opens Inventory tab. List of redeemed rewards should be passed to the widget.
    public func onGetClaimedRewards(_ handler: @escaping OnGetClaimedRewardsHandler) -> CerebellumWidget {
        self.queueHandler({() in
            self.bridge?.registerHandler("onGetClaimedRewards",
                                         handler: OnGetClaimedRewardsHandlerMapper(handler).map());
        });
        
        return self;
    }
    
    /// Sets handler to be called when user provides email in the widget to ask hosting app if the user is registered in the app.
    public func onGetUserByEmail(_ handler: @escaping OnGetUserByEmailHandler) -> CerebellumWidget {
        self.onGetUserByEmailHandler = handler;
        
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
                                    userId: String?,
                                    appId: String,
                                    env: String,
                                    mode: String,
                                    sections: String) -> String {
        return template
            .replacingOccurrences(of: "::widgetUrl::", with: widgetUrl)
            .replacingOccurrences(of: "::userId::", with: userId ?? "")
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

    private func setupDefaultHandlers() {
        self.queueHandler({() in
            self.bridge?.registerHandler("onGetUserByEmail",
                                         handler: OnGetUserByEmailHandlerMapper({(
                                            email: String,
                                            callback: @escaping GetUserByEmailCallback) in
                                            if (self.onGetUserByEmailHandler != nil) {
                                                self.onGetUserByEmailHandler!(email, callback);
                                            } else {
                                                callback(false);
                                            }
                                         }).map());
            
            self.bridge?.registerHandler("onSignIn",
                                         handler: OnSignInHandlerMapper({(
                                            email: String,
                                            token: String,
                                            extras: [String: String]) in
                                            if (self.onSignInHandler != nil) {
                                                self.onSignInHandler!(email, token, extras);
                                            } else {
                                                self.setMode(mode: WidgetMode.REWARDS);
                                            }
                                         }).map());

            
            self.bridge?.registerHandler("onSignUp",
                                         handler: OnSignUpHandlerMapper({(
                                            email: String,
                                            token: String,
                                            password: String,
                                            extras: [String: String]) in
                                            if (self.onSignUpHandler != nil) {
                                                self.onSignUpHandler!(email, token, password, extras);
                                            } else {
                                                self.setMode(mode: WidgetMode.REWARDS);
                                            }
                                         }).map());
        });
    }
}
