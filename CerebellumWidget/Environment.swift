//
//  Environment.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/2/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

/// Struct to set the widget running environment. It contains settings to work in specified environments.
/// `STAGE` and `PRODUCTION` should only be used.
public struct Environment {
    /// Configuration property for Local environment.
    public static let LOCAL: Environment = Environment("local", "http://192.168.100.2:3011", "http://192.168.100.2:3002");
    
    /// Configuration property for Dev1 environment.
    static let DEV1: Environment = Environment("dev1", "https://widget-sdk.dev.cere.io", "https://widget.dev.cere.io");
    
    /// Configuration property for Stage environment.
    public static let STAGE: Environment = Environment("stage", "https://widget-sdk.stage.cere.io", "https://widget.stage.cere.io");
    
    /// Configuration property for Production environment.
    public static let PRODUCTION: Environment = Environment("production", "https://widget-sdk.cere.io", "https://widget.cere.io");
    
    /// Name of environment.
    public let name: String;
    
    /// Url to widget-sdk server.
    public let sdkURL: String;
    
    /// Url to widget-ui server.
    public let widgetURL: String;
    
    /// Constant value for path to main bundle script file.
    public static let bundleJSPath = "/static/js/bundle.js";
    
    init(_ name: String, _ sdkURL: String, _ widgetURL: String) {
        self.name = name;
        self.sdkURL = sdkURL;
        self.widgetURL = widgetURL;
    }
}
