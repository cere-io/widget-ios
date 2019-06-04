//
// RewardsModule.swift
// RewardsModule
//
//  Created by Konstantin on 1/31/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import WebViewJavascriptBridge
import SwiftyJSON

/// Class that implements RewardsModuleProtocol and provides all the functionality of the widget.
///
public class RewardsModule: NSObject, RewardsModuleProtocol, WKNavigationDelegate {
    var webView: WKWebView?;
    var bridge: WebViewJavascriptBridge?;
    var _parentController: UIViewController?;
    var onInitializationFinishedHandler: OnInitializationFinishedHandler?;
    var onGetUserByEmailHandler: OnGetUserByEmailHandler?;
    var onSignInHandler: OnSignInHandler?;
    var onSignUpHandler: OnSignUpHandler?;
    var onHideHandler: OnHideHandler?;
    var onGetClaimedRewardsHandler: OnGetClaimedRewardsHandler?;

    internal var env: Environment = Environment.PRODUCTION;
    private var mode: WidgetMode = WidgetMode.REWARDS;
    private var appId: String = "";
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
    /// - Parameter applicationId: identifier of the application from RMS.
    /// - Parameter env: Environment for running the widget (`PRODUCTION` is default).
    public func initialize(applicationId: String, env: Environment = Environment.PRODUCTION) {
        determineCurrentVersion();

        if (widgetInitialized) {
            return;
        }

        self.appId = applicationId;
        self.env = env;

        load();
        setupDefaultHandlers();
    }

    /// Shows the widget if it is hidden.
    public func show(placement: String) {
        self.queueHandler({() in
            self.setView(visible: true);
            _ = self.executeJS(method: "show", withParams: "\"\(placement)\"");
        });
    }

    /// Checks whether widget has items in specified placement. If nothing is specified then it checks if there are items in any placement.
    public func hasItems(forPlacement: String) -> Bool {
        if (self.widgetInitialized) {
            return self.evaluateJS(method: "hasItems", withParams: "\"\(forPlacement)\"") == "true";
        }

        return false;
    }

    /// Returns array of placements that are available for current RMS configuration
    public func getPlacements() -> [String] {
        if (self.widgetInitialized) {
            let list = self.evaluateJS(method: "getPlacements");

            if (list != nil) {
                return JSON(parseJSON: list!).arrayValue.map { value in value.stringValue };
            }
        }

        return [];
    }

    /// Hides the widget.
    public func hide() {
        self.queueHandler({() in
            self.setView(visible: false);
        });
    }

    /// Sets email or phone as username.
    public func setUsername(_ username: String) {
        self.queueHandler({() in
            _ = self.executeJS(method: "setUsername", withParams: "'\(username)'");
        });
    }

    /// Sets additional id for the user that will be sent within conversion server call.
    public func identifyUser(_ externalUserId: String) {
        self.queueHandler({() in
            _ = self.executeJS(method: "identifyUser", withParams: "'\(externalUserId)'");
        });
    }

    /// Sets widget to sign-up mode and shows it.
    public func showOnboarding() {
        _ = self.executeJS(method: "showOnboarding");
    }

    private func setMode(mode: WidgetMode) {
        self.mode = mode;

        self.queueHandler({() in
            _ = self.executeJS(method: "setMode", withParams: "'\(String(describing: self.mode).lowercased())'");
        });
    }

    /// Sets additional information to be shown in widget in JSON format. Only `level` is supported now.
    /// Example:
    /// ```JSON
    ///     {
    ///         userData:
    ///         {
    ///             name: "John Doe"
    ///         }
    ///     }
    public func setUserData(data: String) {
        self.queueHandler({() in
            _ = self.executeJS(method: "setUserData", withParams: data);
        });
    }

    /// Sets custom size for the widget. Parameters should be specified in percentage of screen bounds.
    public func resize(left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) {
        self.leftPercentage = left;
        self.topPercentage = top;
        self.widthPercentage = width;
        self.heightPercentage = height;

        self.initWidgetSize();
    }

    /// Refreshes screen bounds and redraws the widget. This method should be called inside handler of parent view.
    /// Example:
    /// ```swift
    /// override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    ///     super.viewWillTransition(to: size, with: coordinator);
    ///
    ///     coordinator.animate(alongsideTransition: nil, completion: { _ in
    ///         self.rewardsModule.redraw();
    ///     });
    /// }
    public func redraw() {
        self.initWidgetSize();
        self.webView!.frame = self.defaultFrame!;
    }

    /// Logs out of the widget.
    public func logout() {
        self.queueHandler({() in
            _ = self.executeJS(method: "logout");
        });
    }

    /// Sets handler that is called when widget is finished initialization.
    public func onInitializationFinished(_ handler: @escaping OnInitializationFinishedHandler) -> RewardsModule {
        self.onInitializationFinishedHandler = handler;

        if (self.widgetInitialized) {
            handler();
        }

        return self;
    }

    /// Sets handler that is called on widget closed.
    public func onHide(_ handler: @escaping OnHideHandler) -> RewardsModule {
        self.onHideHandler = handler;

        return self;
    }

    /// Sets handler to be called when user finished sign up flow.
    public func onSignUp(_ handler: @escaping OnSignUpHandler) -> RewardsModule {
        self.onSignUpHandler = handler;

        return self;
    }

    /// Sets handler to be called when user successfully signed in to the widget.
    public func onSignIn(_ handler: @escaping OnSignInHandler) -> RewardsModule {
        self.onSignInHandler = handler;

        return self;
    }

    /// Sets handler to be called when user opens Inventory tab. List of redeemed rewards should be passed to the widget.
    public func onGetClaimedRewards(_ handler: @escaping OnGetClaimedRewardsHandler) -> RewardsModule {
        self.queueHandler({() in
            self.bridge?.registerHandler("onGetClaimedRewards",
                                         handler: OnGetClaimedRewardsHandlerMapper(handler).map());
        });

        return self;
    }

    /// Sets handler to be called when user provides email in the widget to ask hosting app if the user is registered in the app.
    public func onGetUserByEmail(_ handler: @escaping OnGetUserByEmailHandler) -> RewardsModule {
        self.onGetUserByEmailHandler = handler;

        return self;
    }

    /// Sets parent view controller that will host the widget view and is responsible for showing/hiding the widget. If the property is not set then current top most view controller is used.
    public var parentController: UIViewController {
        get {
            return self._parentController != nil ? self._parentController! : UIApplication.getTopMostViewController()!;
        }

        set(controller) {
            self._parentController = controller;

            if (self.webView != nil) {
                self.parentController.view.addSubview(self.webView!);
            }
        }
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

        self.bridge!._evaluateJavascript(js);
    }

    func evaluateJS(method: String, withParams: String = "") -> String? {
        let js = "window.CRBWidget." + method + "(" + withParams + ");";

        return self.webView?.evaluate(script: js);
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
        self.parentController.view.addSubview(self.webView!);
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
                "\(env.widgetURL)/native.html?platform=ios&v=\(self.version)&appId=\(self.appId)&mode=\(String(describing: self.mode).lowercased())&env=\(self.env.name)")!));
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
        print("Rewards Module loading error: \(error.localizedDescription)");

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.loadContent();
        }
    }

    private func determineCurrentVersion() {
        self.version = Bundle.init(for: type(of: self)).object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String;

        print("Rewards Module Version: ", version);
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
            self.bridge?.registerHandler("onGetClaimedRewards",
                                         handler: OnGetClaimedRewardsHandlerMapper({(
                                            callback: @escaping GetClaimedRewardsCallback) in
                                            if (self.onGetClaimedRewardsHandler != nil) {
                                                self.onGetClaimedRewardsHandler!(callback);
                                            } else {
                                                callback([]);
                                            }
                                         }).map());

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
