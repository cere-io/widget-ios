//
//  WidgetMode.swift
// CerebellumWidget
//
//  Created by Konstantin on 2/3/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation

/// Enum for setting widget mode.
public enum WidgetMode : String {
    
    /// This mode is used to provide login functionality for the application.
    case LOGIN = "LOGIN"
    
    /// Default mode. It is used to show rewards and sharing capability of the widget.
    case REWARDS = "REWARDS"
}
