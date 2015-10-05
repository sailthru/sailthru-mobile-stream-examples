# Carnival Message Stream Examples
This repo contains a sample project with several examples of possible custom message streams. The point of these examples is to be copied into your own project and modified to suit the look and feel of the application.

## Requirements
These projects require iOS 8.0+. The examples are provided in both Swift 2.X and Objective-C.

Need Swift 1.2 Code? Please [get in touch](support@carnival.io).

## Dependencies
This project uses [CocoaPods](cocoapods.org). The list of pods in use is viewable in the Podfile. You'll need to copy those into your own Podfile when copying the files across to your project. Don't forget to run `pod install` after this. 

## Examples
Both Example projects contains 2 streams. 

1. A List Card Example
2  A Graphical Card Example

## Installation
To install, simply copy the files across to your project. Update your Podfile with the Pods we rely on. For Swift projects, also update your bridging header file. 

## Your decisions 

### Managing unread counts

It's up to you to decide how you'll define as a reading a message. There are a few options

* When the In App Notification is presented (use the delegate to mark as read)
* When the message is shown in the stream
* When the message is tapped, and the detail for the message is shown. 

### Colors and Fonts
Feel free to change these for your app.

### Detail View
You can either us the defaul detail view (as these examples do) or create your own. 

## Contributing
These examples are fully open source! If you'd like to suggest an improvement, make an improvement or report and issue - please do! We'll review them ASAP and get back to you. 

If you customise the examples in a big way, please comit them back to the app so others can benefit too. 

## Docs and Support
Our docs are at [docs.carnival.io](docs.carnival.io) for more information. Any questions? Create an issue or email at [support@carnival.io](support@carnival.io).
