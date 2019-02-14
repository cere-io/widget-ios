//
//  AdditionalRewardItemInfo.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/13/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

public class AdditionalRewardItemInfo {
    public var code: String;      // `Code: ${this._getCode(item)}`,
    public var orderId: String;   // `Order ID: ${this._getOrderId(item)}`,
    public var createdAt: String; // `Created: ${this._getCreatedAt(item)}`,
    
    public init (code: String, orderId: String, createdAt: String) {
        self.code = code;
        self.orderId = orderId;
        self.createdAt = createdAt;
    }
}
