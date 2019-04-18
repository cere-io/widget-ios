//
//  Environment.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/2/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation

/// Struct to set the widget running environment. It contains settings to work in specified environments.
/// `STAGE` and `PRODUCTION` should only be used.
public struct Environment {
    /// Configuration property for Local environment.
    public static let LOCAL: Environment = Environment("local", "http://192.168.100.2:3002");
    
    /// Configuration property for Dev1 environment.
    static let DEV1: Environment = Environment("dev1", "https://widget.dev.cere.io");
    
    /// Configuration property for Stage environment.
    public static let STAGE: Environment = Environment("stage", "https://widget.stage.cere.io");
    
    /// Configuration property for Production environment.
    public static let PRODUCTION: Environment = Environment("production", "https://widget.cere.io");
    
    /// Name of environment.
    public let name: String;
    
    /// Url to widget-ui server.
    public let widgetURL: String;
    
    init(_ name: String, _ widgetURL: String) {
        self.name = name;
        self.widgetURL = widgetURL;
    }
}
