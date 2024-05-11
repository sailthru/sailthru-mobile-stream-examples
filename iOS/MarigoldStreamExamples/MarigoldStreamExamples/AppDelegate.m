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
    [[Marigold new] startEngine:@"6c566d865f4d647ab6f2c9f2653d670090751b80" error:nil];

    return YES;
}

@end
