//
//  AppDelegate.m
//  CarnivalStreamExamples
//
//  Created by Sam Jarman on 6/08/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

#import "AppDelegate.h"
#import <Carnival/Carnival.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    [Carnival startEngine:@"f0f9e7185392a99a09403d9dc000ed35b1758794"];

    return YES;
}

@end
