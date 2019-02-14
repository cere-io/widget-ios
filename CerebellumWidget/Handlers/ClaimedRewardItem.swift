//
//  ClaimedRewardItem.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/13/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

public class ClaimedRewardItem {
    public var title: String;
    public var imageUrl: String;
    public var price: Decimal;
    public var currency: String;
    public var additionalInfo: AdditionalRewardItemInfo;
    
    public init(title: String, imageUrl: String, price: Decimal, currency: String, additionalInfo: AdditionalRewardItemInfo) {
        self.title = title;
        self.imageUrl = imageUrl;
        self.price = price;
        self.currency = currency;
        self.additionalInfo = additionalInfo;
    }
}
