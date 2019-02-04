//
//  WidgetViewController.swift
//  WidgetView
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

    private let env: Environment = Environment.STAGE;
    private let mode: WidgetMode = WidgetMode.REWARDS;
    private var appId: String = "";
    private var userId: String = "";
    private var sections: [String] = [];
    private var widgetInitialized = false;
    private var handlerQueue: [()->Void] = [];
    
    public override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    public override func loadView() {
        super.loadView();
    }
    
    public func initAndLoad(parentController: UIViewController, userId: String, appId: String, sections: [String]) {
        self.parentController = parentController;
        self.userId = userId;
        self.appId = appId;
        self.sections = sections;
        
        load();
    }
    
    public func show() -> WidgetViewController {
        self.queueHandler({() in
            self.setView(visible: true);
        
            self.executeJS(method: "expand");
        });
        
        return self;
    }
    
    public func resize(width: CGFloat, height: CGFloat) {
        self.webView?.frame.size.height = height;
        self.webView?.frame.size.width = width;
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
        }
    }
    
    func executeJS(method: String, withParams: String = "") {
        let js = "window.CRBWidget." + method + "(" + withParams + ");";
        
        self.bridge?._evaluateJavascript(js);
    }
    
    func load() {
        let configuration = WKWebViewConfiguration();
        let s = UIScreen.main.bounds;
        let viewSize = CGRect(x: 0, y: s.minY + 0, width: s.width, height: s.height);
        
        self.webView = WKWebView(frame: viewSize, configuration: configuration);
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
