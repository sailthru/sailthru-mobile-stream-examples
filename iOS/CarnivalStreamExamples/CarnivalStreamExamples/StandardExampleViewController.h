//
//  StandardExampleViewController.h
//  CarnivalStreamExamples
//
//  Created by Sam Jarman on 27/10/15.
//  Copyright © 2015 Carnival Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StandardExampleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIBarPositioningDelegate>
- (IBAction)refreshTableView;

@end