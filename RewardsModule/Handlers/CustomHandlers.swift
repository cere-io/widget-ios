//
//  CustomHandlers.swift
//  RewardsModule
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import Foundation

/// Type for onHide event handler.
public typealias OnHideHandler = () -> Void;

/// Type for onSignUp event handler.
/// - Parameter email: email of the user that finished sign up flow.
/// - Parameter token: jwt token of the user to be used for later signin to the widget.
/// - Parameter password: password of the user that finished sign up flow.
/// - Parameter extras: answers on the additional questions that was specified in RMS for new users.
public typealias OnSignUpHandler = (_ email: String,
                                    _ token: String,
                                    _ password: String,
                                    _ extras: [String: String]) -> Void;

/// Type for onSignIn event handler.
/// - Parameter email: email of the user that finished sign up flow.
/// - Parameter token: jwt token of the user to be used for later signin to the widget.
/// - Parameter extras: answers on the additional questions that was specified in RMS for new users.
public typealias OnSignInHandler = (_ email: String,
                                    _ token: String,
                                    _ extras: [String: String]) -> Void;

/// Type for onGetClaimedRewards event handler.
public typealias OnGetClaimedRewardsHandler = (_ callback: @escaping GetClaimedRewardsCallback) -> Void;
/// Type for GetClaimedRewardsCallback parameter that is used for onGetClaimedRewards event handler.
public typealias GetClaimedRewardsCallback = (_ data: [ClaimedRewardItem]) -> Void;

/// Type for OnGetUserByEmail event handler.
public typealias OnGetUserByEmailHandler = (_ email: String,
                                            _ callback: @escaping GetUserByEmailCallback) -> Void;
/// Type for GetUserByEmailCallback parameter that is used for onGetUserByEmail event handler.
public typealias GetUserByEmailCallback = (_ exists: Bool) -> Void;

/// Type for onInitializationFinished event handler.
public typealias OnInitializationFinishedHandler = () -> Void;
