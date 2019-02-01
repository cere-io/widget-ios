//
//  JSCallbackList.swift
//  WidgetView
//
//  Created by Konstantin on 2/1/19.
//  Copyright © 2019 Funler LLC. All rights reserved.
//

import Foundation

let JSCallbackList: [String: JsProtocolWithResponse] = [
    "setNativeStorageItem": SetNativeStorageItemWrapper(),
    "getNativeStorageItem": GetNativeStorageItemWrapper(),
    "initialized": InitializedWrapper(),
];
