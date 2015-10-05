//
//  ScreenSizeHelper.h
//  CarnivalStreamExamples
//
//  Created by Adam Jones on 21/09/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define IS_IPHONE_5_OR_LESS (SCREEN_WIDTH <= 320 || SCREEN_HEIGHT <= 320)

#define TEXT_SMALL 9
#define TEXT_NORMAL 12