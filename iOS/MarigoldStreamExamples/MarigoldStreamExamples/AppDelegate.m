//
//  AppDelegate.m
//  MarigoldStreamExamples
//
//  Created by Sam Jarman on 6/08/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
//

#import "AppDelegate.h"
#import <Marigold/Marigold.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    [[Marigold new] startEngine:@"" error:nil];

    return YES;
}

@end
