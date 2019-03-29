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
public class CerebellumWidget: NSObject, CerebellumWidgetProtocol, WKNavigationDelegate {
    var webView: WKWebView?;
    var bridge: WebViewJavascriptBridge?;
    var parentController: UIViewController?;
    var onInitializationFinishedHandler: OnInitializationFinishedHandler?;
    var onGetUserByEmailHandler: OnGetUserByEmailHandler?;
    var onSignInHandler: OnSignInHandler?;
    var onSignUpHandler: OnSignUpHandler?;
    var onHideHandler: OnHideHandler?;

    internal var env: Environment = Environment.PRODUCTION;
    private var mode: WidgetMode = WidgetMode.REWARDS;
    private var appId: String = "";
    private var sections: [String] = [];
    private var widgetInitialized = false;
    private var handlerQueue: [()->Void] = [];
    private var version: String = "unknown";
    
    /// Stores initial size of the widget. Default value is whole screen size, but frame with width * frameGapFactor and height * frameGapFactor.
    public var defaultFrame: CGRect?;
    
    private var leftPercentage: CGFloat = 5;
    private var topPercentage: CGFloat = 5;
    private var widthPercentage: CGFloat = 90;
    private var heightPercentage: CGFloat = 90;

    /// Initializes and prepares the widget for usage.
    /// - Parameter: parentController: controller that will host the widget view and is responsible for showing/hiding the widget.
    /// - Parameter: applicationId: identifier of the application from RMS.
    /// - Parameter: sections: (optional) section name from RMS with rewards. It is used if you need to show widget in
    /// more than one place in your application with different rewards.
    /// - Parameter: env: Environment for running the widget (`PRODUCTION` is default).
    ///
    public func initAndLoad(parentController: UIViewController, applicationId: String, sections: [String] = ["default"], env: Environment = Environment.PRODUCTION) {
        determineCurrentVersion();
        
        if (widgetInitialized) {
            return;
        }

        self.parentController = parentController;
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
    
    /// Sets custom size for the widget. Parameters should be specified in percentage of screen bounds.
    public func resize(left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) {
        self.leftPercentage = left;
        self.topPercentage = top;
        self.widthPercentage = width;
        self.heightPercentage = height;
        
        self.redraw();
    }
    
    /// Refreshes screen bounds and redraws the widget. This method should be called inside handler of parent view.
    /// Example:
    /// ```swift
    /// override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    ///     super.viewWillTransition(to: size, with: coordinator);
    ///
    ///     coordinator.animate(alongsideTransition: nil, completion: { _ in
    ///         self.crbWidget.redraw();
    ///     });
    /// }
    public func redraw() {
        self.initWidgetSize();
        self.webView!.frame = self.defaultFrame!;
    }
    
    /// Logs out of the widget.
    public func logout() {
        self.queueHandler({() in
            self.executeJS(method: "logout");
        });
    }
    
    /// Sets handler that is called when widget is finished initialization.
    public func onInitializationFinished(_ handler: @escaping OnInitializationFinishedHandler) -> CerebellumWidget {
        self.onInitializationFinishedHandler = handler;
        
        return self;
    }
    
    /// Sets handler that is called on widget closed.
    public func onHide(_ handler: @escaping OnHideHandler) -> CerebellumWidget {
        self.onHideHandler = handler;

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
        initWidgetSize();
        createViewAndAddAsSubview();
        attachBridge();
        loadContent();
    }
    
    func createViewAndAddAsSubview() {
        let configuration = WKWebViewConfiguration();
        
        self.webView = WKWebView(frame: .zero, configuration: configuration);
        self.webView!.navigationDelegate = self;
        self.parentController!.view.addSubview(self.webView!);
    }
    
    func initWidgetSize() {
        let s = UIScreen.main.bounds;
        
        self.defaultFrame = CGRect(
            x: s.minX + s.width * self.leftPercentage / 100,
            y: s.minY + s.height * self.topPercentage / 100,
            width: s.width * self.widthPercentage / 100,
            height: s.height * self.heightPercentage / 100);
    }
    
    func loadContent() {
        self.webView!.load(URLRequest(url:
            URL(string:
                "\(env.widgetURL)/native.html?platform=ios&v=\(self.version)&appId=\(self.appId)&mode=\(String(describing: self.mode).lowercased())&env=\(self.env.name)&sections=\(self.sections.joined(separator: ","))")!));
    }
    
    func attachBridge() {
        self.bridge = WebViewJavascriptBridge(forWebView: webView);
        
        if (self.env.name != Environment.PRODUCTION.name) {
            WebViewJavascriptBridge.enableLogging();
        }
        
        registerEventHandlers();
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
    
    private func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Cerebellum Widget loading error: \(error.localizedDescription)");
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.loadContent();
        }
    }
    
    private func determineCurrentVersion() {
        self.version = Bundle.init(for: type(of: self)).object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String;
        
        print("Cerebellum Widget Version: ", version);
    }
    
    private func registerEventHandlers() {
        for jsCallback in JSCallbackList {
            bridge!.registerHandler(jsCallback.key, handler: { (data, responseCallback) in
                
                jsCallback.value.handleEvent(widget: self, data: data as AnyObject, responseCallback: responseCallback);
            })
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
