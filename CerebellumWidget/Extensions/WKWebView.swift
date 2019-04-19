//
//  WKWebView.swift
//  CerebellumWidget
//
//  Created by Konstantin on 4/19/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import WebKit

extension WKWebView {
    func evaluate(script: String) -> String? {
        var finished = false;
        var result: String?;
        
        evaluateJavaScript("var ____r____ = \(script); JSON.stringify(____r____);") { (r, e) in
            result = r as! String?;
            finished = true;
        }
        
        while !finished {
            RunLoop.current.run(mode: .default, before: Date.distantFuture);
        }
        
        return result;
    }
}
