//
//  Environment.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/2/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

public struct Environment {
    public static let LOCAL: Environment = Environment("local", "http://192.168.100.2:3011", "http://192.168.100.2:3002");
    static let DEV1: Environment = Environment("dev1", "https://widget-sdk.dev.cere.io", "https://widget.dev.cere.io");
    public static let STAGE: Environment = Environment("stage", "https://widget-sdk.stage.cere.io", "https://widget.stage.cere.io");
    public static let PRODUCTION: Environment = Environment("production", "https://widget-sdk.cere.io", "https://widget.cere.io");
    
    public let name: String;
    public let sdkURL: String;
    public let widgetURL: String;
    public static let bundleJSPath = "/static/js/bundle.js";
    
    init(_ name: String, _ sdkURL: String, _ widgetURL: String) {
        self.name = name;
        self.sdkURL = sdkURL;
        self.widgetURL = widgetURL;
    }
}
