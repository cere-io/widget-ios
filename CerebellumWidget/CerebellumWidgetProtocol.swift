//
//  CerebellumWidgetProtocol.swift
//  CerebellumWidget
//
//  Created by Konstantin on 3/18/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

/// Protocol that contains all API methods of CerebellumWidget.
public protocol CerebellumWidgetProtocol {
    
    /// This method should show the widget.
    func show();
    
    /// This method should hide the widget.
    func hide();
    
    /// The method to set values for widget fields (like email, confirm. code, etc.)
    func sendDataToField(fieldName: String, value: String);
    
    /// The method to set widget mode.
    func setMode(mode: WidgetMode);
    
    /// The method to set additional data related to current widget user.
    func setUserData(data: String);
    
    /// This method should minimize the widget.
    func collapse();
    
    /// This method should expand the widget on full screen.
    func expand();
    
    /// This method should restore the widget to initial size after calling expand().
    func restore();
    
    /// This method should set custom size for the widget.
    func resize(width: CGFloat, height: CGFloat);
    
    /// This method should log out the widget's user.
    func logout();
    
    /// The metod to set handler for `onInitializationFinished` event.
    func onInitializationFinished(_ handler: @escaping OnInitializationFinishedHandler) -> CerebellumWidget;
    
    /// The metod to set handler for `onHide` event.
    func onHide(_ handler: @escaping OnHideHandler) -> CerebellumWidget;
    
    /// The metod to set handler for `onSignUp` event.
    func onSignUp(_ handler: @escaping OnSignUpHandler) -> CerebellumWidget;
    
    /// The metod to set handler for `onSignIn` event.
    func onSignIn(_ handler: @escaping OnSignInHandler) -> CerebellumWidget;
    
    /// The metod to set handler for `onProcessNonFungibleReward` event.
    func onProcessNonFungibleReward(_ handler: @escaping OnProcessNonFungibleRewardHandler) -> CerebellumWidget;
    
    /// The metod to set handler for `onGetClaimedRewards` event.
    func onGetClaimedRewards(_ handler: @escaping OnGetClaimedRewardsHandler) -> CerebellumWidget;
    
    /// The metod to set handler for `onGetUserByEmail` event.
    func onGetUserByEmail(_ handler: @escaping OnGetUserByEmailHandler) -> CerebellumWidget;
}
