//
//  GraphicalCardsViewController.h
//  MarigoldStreamExamples
//
//  Created by Sam Jarman on 9/09/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphicalCardsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIBarPositioningDelegate>

- (IBAction)refreshTableView;

@end
