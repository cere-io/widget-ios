//
//  JSCallbackList.swift
// CerebellumWidget
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

let JSCallbackList: [String: JsProtocolWithResponse] = [
    "setNativeStorageItem": SetNativeStorageItemWrapper(),
    "getNativeStorageItem": GetNativeStorageItemWrapper(),
    "initialized": InitializedWrapper(),
    "collapse": CollapseWrapper(),
    "expand": ExpandWrapper(),
    "restore": RestoreWrapper(),
    "show": ShowWrapper(),
    "hide": HideWrapper(),
    "logout": LogoutWrapper(),
    "share": ShareWrapper(),
    "shareWith": ShareWithWrapper(),
    "getReferralsInfo": GetReferralsInfoWrapper(),
    "showNativeMessage": ShowNativeMessageWrapper(),
];
