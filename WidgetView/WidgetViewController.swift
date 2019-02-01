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
    public var webView: WKWebView?;
    public var viewUrl = "";
    var bridge: WebViewJavascriptBridge?;
    
    public override func viewDidLoad() {
        super.viewDidLoad();
        do {
            if viewUrl != "" {
                let path = Bundle(for: type(of: self)).path(forResource: "index", ofType: "html");
                let content = try String(contentsOfFile: path!,
                                         encoding: String.Encoding.utf8);
            self.webView!.loadHTMLString(content, baseURL: URL(string: viewUrl)!);
        }
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
    
    func attachBridge() {
        self.bridge = WebViewJavascriptBridge(forWebView: webView);
        
        WebViewJavascriptBridge.enableLogging();
        
        for jsCallback in JSCallbackList {
            bridge!.registerHandler(jsCallback.key, handler: { (data, responseCallback) in
                jsCallback.value.handleEvent(data as AnyObject, responseCallback: responseCallback);
            })
        }
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}
