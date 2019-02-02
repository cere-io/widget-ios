//
//  Environment.swift
//  WidgetView
//
//  Created by Konstantin on 2/2/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

internal struct Environment {
    static let LOCAL: Environment = Environment("local", "", "");
    static let DEV1: Environment = Environment("dev1", "https://widget-sdk.dev.cere.io", "https://widget.dev.cere.io");
    static let STAGE: Environment = Environment("stage", "https://widget-sdk.stage.cere.io", "https://widget.stage.cere.io");
    static let PRODUCTION: Environment = Environment("production", "https://widget-sdk.cere.io", "https://widget.cere.io");
    
    public let name: String;
    public let sdkURL: String;
    public let widgetURL: String;
    public static let bundleJsPath = "/static/js/bundle.js";
    
    init(_ name: String, _ sdkURL: String, _ widgetURL: String) {
        self.name = name;
        self.sdkURL = sdkURL;
        self.widgetURL = widgetURL;
    }
}
