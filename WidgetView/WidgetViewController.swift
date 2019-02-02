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
    
    public override func viewDidLoad() {
        super.viewDidLoad();
        do {
            let template = try loadHtmlTemplate();
            let content = insertParametersToTemplate(template,
                                                     sdkUrl: env.sdkURL);
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
                                    sdkUrl: String) -> String {
        return template
            .replacingOccurrences(of: "::widgetUrl::", with: sdkUrl + Environment.bundleJsPath)
            .replacingOccurrences(of: "::userId::", with: "")
            .replacingOccurrences(of: "::appId::", with: "")
            .replacingOccurrences(of: "::env::", with: "")
            .replacingOccurrences(of: "::mode::", with: "")
            .replacingOccurrences(of: "::sections::", with: "");
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}
