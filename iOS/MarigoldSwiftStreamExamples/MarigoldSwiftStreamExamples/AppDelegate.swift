//
//  AppDelegate.swift
//  MarigoldSwiftStreamExamples
//
//  Created by Sam Jarman on 10/08/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
//

import UIKit
import Marigold

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        // Override point for customization after application launch.        
        do {
            try Marigold().startEngine("")
        } catch {
            print("SDK Key Error: \(error)")
        }
        
        return true
    }
}
