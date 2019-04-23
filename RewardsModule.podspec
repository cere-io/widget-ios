#
#  Be sure to run `pod spec lint RewardsModule.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "RewardsModule"
  s.version      = "2.0.2"
  s.summary      = "Rewards Module SDK for iOS."
  s.description  = "The library includes all the stuff required to embed Rewards Module to your iOS application."
  s.homepage     = "http://cere.io"

  s.license      = "MIT"

  s.author             = { "Cerebellum Network, Inc." => "info@cere.io" }

  s.platform     = :ios, "9.0"
  
  s.source       = { :git => "git@github.com:cere-io/widget-ios.git", :tag => s.version }

  s.source_files  = "RewardsModule/**/*.swift"

  s.swift_version = "4.2" 

  s.dependency "WebViewJavascriptBridge", "~>6.0"
  s.dependency "SwiftyJSON"

end
