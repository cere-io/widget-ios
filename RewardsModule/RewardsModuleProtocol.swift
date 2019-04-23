//
//  RewardsModuleProtocol.swift
//  RewardsModule
//
//  Created by Konstantin on 3/18/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation

/// Protocol that contains all API methods of RewardsModule.
public protocol RewardsModuleProtocol {
    
    /// This method should show the widget for specified placement.
    func show(placement: String);

    /// This method should check whether widget has items in specified placement.
    func hasItems(forPlacement: String) -> Bool;
    
    /// This method should return array of placements that are available for current RMS configuration.
    func getPlacements() -> [String];
    
    /// This method should hide the widget.
    func hide();
    
    /// Sets email or phone as username.
    func setUsername(_ username: String);
    
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
    func onInitializationFinished(_ handler: @escaping OnInitializationFinishedHandler) -> RewardsModule;
    
    /// The metod to set handler for `onHide` event.
    func onHide(_ handler: @escaping OnHideHandler) -> RewardsModule;
    
    /// The metod to set handler for `onSignUp` event.
    func onSignUp(_ handler: @escaping OnSignUpHandler) -> RewardsModule;
    
    /// The metod to set handler for `onSignIn` event.
    func onSignIn(_ handler: @escaping OnSignInHandler) -> RewardsModule;
    
    /// The metod to set handler for `onGetClaimedRewards` event.
    func onGetClaimedRewards(_ handler: @escaping OnGetClaimedRewardsHandler) -> RewardsModule;
    
    /// The metod to set handler for `onGetUserByEmail` event.
    func onGetUserByEmail(_ handler: @escaping OnGetUserByEmailHandler) -> RewardsModule;
}
