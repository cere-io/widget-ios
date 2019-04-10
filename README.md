# iOS SDK for Cerebellum Widget 

## About

This project allows with a quick and simple interface to include Cerebellum inside your iOS Application.

## Installation

The easiest way to integrate widget to iOS application is to use CocoaPods. In your Podfile add the following line:

    pod 'CerebellumWidget', :git => 'git@github.com:funler/widget-ios.git'

then run the following command to install new pod:

    pod install

That's it. Or you can use classic way:

1. Create a copy of latest version of this project (We recommend add it as a submodule of your project)
2. Open your iOS Project inside Xcode.
3. Target your Project and go to General Settings.
4. Under Embedded Binaries Click `+` and then `Add Other ...`
5. Select `CerebellumWidget.xcodeproj` from the copy of this repository, and add it.
6. Now Click `+` again and `CerebellumWidget` should appear, select `CerebellumWidget.framework` and `Add`
7. In case you are using Swift you need to include `CerebellumWidget.h` so you can reference it later

```swift
    #import "../../../widget-ios/CerebellumWidget/CerebellumWidget/CerebellumWidget.h"
``` 

This can be done in any Header bridge you may have.

## Usage

You need to add the widget to any View you would like.
    
```swift
    import CerebellumWidget

    ...

    let crbWidget = CerebellumWidget();

    ...

    self.crbWidget.initAndLoad(
        parentController: self,
        applicationId: "777",
        placement: "MyAppPlacement");
```

Parameter `applicationId` should be taken from RMS and is mandatory. Parameter `placement` depends on your RMS configuration. It is required to set different placements if you need to show widget in more than one place in your application with different rewards/settings.
At this point widget is basically loaded and ready to work. To show it just call:

```swift
    self.crbWidget.show();
```

## API Reference
### Methods

| Signature | Description |
| :-- | :-- |
| initAndLoad | Initializes widget for the app (with parameters are taken from RMS) and loads widget content |
| show | Shows the widget if it was hidden or closed |
| expand | Shows widget expanded on whole screen |
| restore | Restores widget to normal view size after expanding |
| hide | Hides the widget manually |
| collapse | Similar to hide, but is triggered when user clicks minimize button in widget (hidden by default) |
| resize | Resized widget to custom size |
| sendDataToField | Autofills specified field with value to reduce amount of questions to user (i.e. `email`). |
| setMode | Sets widget mode. Currently two modes are supported: REWARDS (default one) and LOGIN |
| setUserData | Sets data required for some fields of the widget like `name` or `level`. Should be passes as JSON string '{userData: {name: "Junior", level: 1}'
| logout | Logs out user from widget |

### Events

| Signature | Description |
| :-- | :-- |
| onHide | Triggered when user clicks close button on widget and it is about to close |
| onSignUp | Triggered when user completes sign up in widget |
| onSignIn | Triggered when user signs in to widget |
| onGetClaimedRewards | List of redeemed rewards should be passed to widget with this event. Triggered when user opens inventory tab |
| onGetUserByEmail | Triggered on sign up to know if user exists in app, but new in the widget |

On more detailed information of using the widget in your app please see CerebellumWidgetExample app.

## Upcoming installation Methods

* Carthage
* Swift package manager

## Pending implementations

* Full social sharing support