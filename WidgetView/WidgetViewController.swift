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
    
    private let env: Environment = Environment.STAGE;
    private let mode: WidgetMode = WidgetMode.REWARDS;
    private var appId: String = "";
    private var userId: String = "";
    private var sections: [String] = [];
    
    public override func viewDidLoad() {
        super.viewDidLoad();
        do {
            let template = try loadHtmlTemplate();
            let content = insertParametersToTemplate(template,
                                                     widgetUrl: env.sdkURL + Environment.bundleJsPath,
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
    
    public override func loadView() {
        super.loadView();
        
        let configuration = WKWebViewConfiguration();
        let s = UIScreen.main.bounds;
        let viewSize = CGRect(x: s.minX + 100, y: s.minY + 100, width: s.width - 100, height: s.height - 100);
        
        self.webView = WKWebView(frame: viewSize, configuration: configuration);
        self.view = self.webView;
        
        attachBridge();
    }
    
    public func initParameters(userId: String, appId: String, sections: [String]) {
        self.userId = userId;
        self.appId = appId;
        self.sections = sections;
    }
    
    public func show(_ parent: UIViewController) {
        parent.addChildViewController(self);
        self.beginAppearanceTransition(true, animated: true)
        parent.view.addSubview(self.webView!);
        self.endAppearanceTransition();
        self.didMove(toParentViewController: self);
    }
    
    func attachBridge() {
        self.bridge = WebViewJavascriptBridge(forWebView: webView);
        
        WebViewJavascriptBridge.enableLogging();
        
        for jsCallback in JSCallbackList {
            bridge!.registerHandler(jsCallback.key, handler: { (data, responseCallback) in
                jsCallback.value.handleEvent(data as AnyObject, responseCallback: responseCallback);
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
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}
