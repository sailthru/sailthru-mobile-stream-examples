//
//  StandardExampleViewController.h
//  MarigoldStreamExamples
//
//  Created by Sam Jarman on 27/10/15.
//  Copyright © 2015 Marigold Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardExampleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIBarPositioningDelegate>
- (IBAction)refreshTableView;

@end
