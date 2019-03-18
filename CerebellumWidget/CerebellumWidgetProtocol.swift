//
//  CerebellumWidgetProtocol.swift
//  CerebellumWidget
//
//  Created by Konstantin on 3/18/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

public protocol CerebellumWidgetProtocol {
    func show();
    
    func hide();
    
    func sendDataToField(fieldName: String, value: String);
    
    func setMode(mode: WidgetMode);
    
    func setUserData(data: String);
    
    func collapse();
    
    func expand();
    
    func restore();
    
    func resize(width: CGFloat, height: CGFloat);
    
    func logout();
    
    func onInitializationFinished(_ handler: @escaping OnInitializationFinishedHandler) -> CerebellumWidget;
    
    func onHide(_ handler: @escaping OnHideHandler) -> CerebellumWidget;
    
    func onSignUp(_ handler: @escaping OnSignUpHandler) -> CerebellumWidget;
    
    func onSignIn(_ handler: @escaping OnSignInHandler) -> CerebellumWidget;
    
    func onProcessNonFungibleReward(_ handler: @escaping OnProcessNonFungibleRewardHandler) -> CerebellumWidget;
    
    func onGetClaimedRewards(_ handler: @escaping OnGetClaimedRewardsHandler) -> CerebellumWidget;
    
    func onGetUserByEmail(_ handler: @escaping OnGetUserByEmailHandler) -> CerebellumWidget;
}
