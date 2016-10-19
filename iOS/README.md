# Carnival Message Stream Examples (iOS)
This repo contains a sample project with several examples of possible custom message streams. The point of these examples is to be copied into your own project and modified to suit the look and feel of the application.

## Requirements
These projects require iOS 8.0+. The examples are provided in both Swift 2.X and Objective-C.

Need Swift 1.2 Code? Please [get in touch](support@carnival.io).

## Dependencies
This project uses [CocoaPods](cocoapods.org). The list of pods in use is viewable in the Podfile. You'll need to copy those into your own Podfile when copying the files across to your project. Don't forget to run `pod install` after this. 

## Examples
Both Example projects contains 4 streams. 

1. A List Card Example
2. A Graphical Card Example
3. A Standard Example
4. A Card Example

## Installation
To install, simply copy the files across to your project. Update your Podfile with the Pods we rely on. For Swift projects, also update your bridging header file. 

```
pod 'DateTools'
pod 'SDWebImage'
```

List Example: 

1. Copy all files in `List Example` and `ScreenSizeHelper` (.h/.m or .swift) into your project.
2. Copy the view controller from the `Main.storyboard` file into your own.
3. Update any custom class Modules value to your own modules. (Click the class, View the Identity inspector)

Graphical Cards Example: 

1. Copy all files in `Graphical Cards Example` and `ScreenSizeHelper` (.h/.m or .swift) into your project.
2. Copy the view controller from the `Main.storyboard` file into your own.
3. Update any custom class Modules value to your own modules. (Click the class, View the Identity inspector)

Standard  Example: 

1. Copy all files in `Standard Example`, `UILabel+HTML`, `ScreenSizeHelper` (.h/.m or .swift) into your project.
2. Copy the view controller from the `Main.storyboard` file into your own.
3. Update any custom class Modules value to your own modules. (Click the class, View the Identity inspector)

Card  Example: 

1. Copy all files in `Card Example`, `UILabel+HTML`, `CarnivalLabel` (.h/.m or .swift) into your project.
2. Copy the view controller from the `Main.storyboard` file into your own.
3. Update any custom class Modules value to your own modules. (Click the class, View the Identity inspector)



The view controller is like any other, integrate the navigation of it in a way that makes sense to your application.

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

### Row Height Caching
We have implemented basic row height caching on the standard and card examples. This technique can be used in any example though, depending on your performance goals. 

## Contributing
These examples are fully open source! If you'd like to suggest an improvement, make an improvement or report and issue - please do! We'll review them ASAP and get back to you. 

If you customise the examples in a big way, please comit them back to the app so others can benefit too. 

## Docs and Support
Our docs are at [docs.carnival.io](docs.carnival.io) for more information. Any questions? Create an issue or email at [support@carnival.io](support@carnival.io).
