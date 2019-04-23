# iOS SDK for Rewards Module

## About

This project allows with a quick and simple interface to include Rewards Module inside your iOS Application.

## Installation

The easiest way to integrate widget to iOS application is to use CocoaPods. In your Podfile add the following line:

    pod 'RewardsModule', :git => 'git@github.com:cere-io/widget-ios.git'

then run the following command to install new pod:

    pod install

That's it. Or you can use classic way:

1. Create a copy of latest version of this project (We recommend add it as a submodule of your project)
2. Open your iOS Project inside Xcode.
3. Target your Project and go to General Settings.
4. Under Embedded Binaries Click `+` and then `Add Other ...`
5. Select `RewardsModule.xcodeproj` from the copy of this repository, and add it.
6. Now Click `+` again and `RewardsModule` should appear, select `RewardsModule.framework` and `Add`
7. In case you are using Swift you need to include `RewardsModule.h` so you can reference it later

```swift
    #import "../../../widget-ios/RewardsModule/RewardsModule/RewardsModule.h"
``` 

This can be done in any Header bridge you may have.

## Usage

You need to add the widget to any View you would like.
    
```swift
    import RewardsModule;

    ...

    var rewardsModule = RewardsModule();

    ...

    self.rewardsModule.initialize(applicationId: "777");
```

Parameter `applicationId` should be taken from RMS and is mandatory. 
At this point widget is basically loaded and ready to work. To show it just call:

```swift
    self.crbWidget.show(placement: "MyAppPlacement");
```
Parameter `placement` depends on your RMS configuration. It is required to set different placements if you need to show widget in more than one place in your application with different rewards/settings.

## API Reference
### Methods

| Signature | Description |
| :-- | :-- |
| initialize | Initializes widget for the specified `applicationId` configuration from RMS and loads widget content |
| show | Shows the widget for specified placement |
| hide | Hides the widget manually |
| resize | Resized widget to custom size |
| setUsername | Sets email or phone as username |
| hasItems | Returns true if there are items for specified `placement` |
| getPlacements | Returns array of placements that are available for current RMS configuration |
| showOnboarding | Sets widget to onboarding mode and shows it to user |
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

On more detailed information of using the widget in your app please see RewardsModuleExample app.

## Upcoming installation Methods

* Carthage
* Swift package manager

## Pending implementations

* Full social sharing support