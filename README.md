# iOS SDK for Cerebellum Widget 

## About

This project will allow you with a quick ans simple interface to include Cerebellum inside your iOS Application.

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

    ```
    #import "../../../widget-ios/CerebellumWidget/CerebellumWidget/CerebellumWidget.h"
    ``` 

    This can be done in any Header bridge you may have.

## Usage

You need to add the widget to any View you would like.
    
    ```
    import CerebellumWidget

    ...

    let crbWidget = CerebellumWidget();

    ...

    self.crbWidget.initAndLoad(
        parentController: self,
        userId: "username",
        appId: "777",
        sections: ["top_section_1", "top_section_2", "top_section_3"]);
    ```

After these lines widget is basically loaded and ready to work. To show it just call:

    crbWidget.setMode(WidgetMode.REWARDS);
    crbWidget.show();

You might need to implement additional handlers in order to enable all features of the widget.

    public func onHide(_ handler: @escaping OnHideHandler) -> CerebellumWidget;
    public func onSignUp(_ handler: @escaping OnSignUpHandler) -> CerebellumWidget;
    public func onSignIn(_ handler: @escaping OnSignInHandler) -> CerebellumWidget
    public func onProcessNonFungibleReward(_ handler: @escaping OnProcessNonFungibleRewardHandler) -> CerebellumWidget;
    public func onGetClaimedRewards(_ handler: @escaping OnGetClaimedRewardsHandler) -> CerebellumWidget;
    public func onGetUserByEmail(_ handler: @escaping OnGetUserByEmailHandler) -> CerebellumWidget;

## Upcoming installation Methods

* Carthage
* Swift package manager

## Pending implementations

* Full social sharing support