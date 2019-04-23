//
//  ClaimedRewardItem.swift
//  RewardsModule
//
//  Created by Konstantin on 2/13/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation

/// Class to define reward item. Instances of this class are used for OnGetClaimedRewards event handler.
public class ClaimedRewardItem {
    
    /// Title of the reward.
    public var title: String;
    
    /// Url to logo image.
    public var imageUrl: String;
    
    /// Reward price.
    public var price: Decimal;
    
    /// Currency of the price value.
    public var currency: String;
    
    /// String instructions on how to redeem the reward.
    public var redemptionInstructions: String;
    
    /// Array of additional information (ref. code, serial number, etc.) that is related to this reward.
    public var additionalInfo: [String];
    
    /// Default constructor.
    public init(title: String, imageUrl: String, price: Decimal, currency: String, redemptionInstructions:String, additionalInfo: [String]) {
        self.title = title;
        self.imageUrl = imageUrl;
        self.price = price;
        self.currency = currency;
        self.redemptionInstructions = redemptionInstructions;
        self.additionalInfo = additionalInfo;
    }
}
