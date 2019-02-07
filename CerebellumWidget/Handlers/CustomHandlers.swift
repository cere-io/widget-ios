//
//  CustomHandlers.swift
//  CerebellumWidget
//
//  Created by Konstantin on 2/4/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

public typealias OnHideHandler = () -> Void;

public typealias OnSignUpHandler = (_ email: String,
                                    _ token: String,
                                    _ password: String,
                                    _ extras: [String: String]) -> Void;

public typealias OnSignInHandler = (_ email: String,
                                    _ token: String,
                                    _ extras: [String: String]) -> Void;

public typealias OnProcessNonFungibleRewardHandler = (_ data: String) -> Void;

public typealias OnGetClaimedRewardsHandler = (_ callback: @escaping GetClaimedRewardsCallback) -> Void;
public typealias GetClaimedRewardsCallback = (_ data: String?) -> Void;

public typealias OnGetUserByEmailHandler = (_ email: String,
                                            _ callback: @escaping GetUserByEmailCallback) -> Void;
public typealias GetUserByEmailCallback = (_ exists: Bool) -> Void;
