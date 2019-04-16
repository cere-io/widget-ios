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
    
    /// This method should show the widget for specified placement.
    func show(placement: String);
    
    /// This method should hide the widget.
    func hide();
    
    /// The method to sets user email.
    func setEmail(email: String);
    
    /// The method sets widget to sign up mode and shows it.
    func showOnboarding();
    
    /// The method to set additional data related to current widget user.
    func setUserData(data: String);
        
    /// Sets custom size for the widget. Parameters should be specified in percentage of screen bounds.
    func resize(left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat);
    
    /// Refreshes screen bounds and redraws the widget. This method should be called inside handler of parent view.
    /// Example:
    /// ```swift
    /// override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    ///     super.viewWillTransition(to: size, with: coordinator);
    ///
    ///     coordinator.animate(alongsideTransition: nil, completion: { _ in
    ///         self.crbWidget.redraw();
    ///     });
    /// }
    func redraw();
    
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
    
    /// The metod to set handler for `onGetClaimedRewards` event.
    func onGetClaimedRewards(_ handler: @escaping OnGetClaimedRewardsHandler) -> CerebellumWidget;
    
    /// The metod to set handler for `onGetUserByEmail` event.
    func onGetUserByEmail(_ handler: @escaping OnGetUserByEmailHandler) -> CerebellumWidget;
}
