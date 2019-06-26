//
//  AppDelegate.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Sam Jarman on 10/08/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        // Override point for customization after application launch.
        Carnival.startEngine("f0f9e7185392a99a09403d9dc000ed35b1758794")
        
        return true
    }
}
