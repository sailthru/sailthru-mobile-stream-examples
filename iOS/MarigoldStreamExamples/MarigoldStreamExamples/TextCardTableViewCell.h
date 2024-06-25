//
//  TextCardTableViewCell.h
//  MarigoldStreamExamples
//
//  Created by Sam Jarman on 9/09/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Marigold/Marigold.h>
#import "MarigoldLabel.h"

@interface TextCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MarigoldLabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;
- (void)configureCellWithMessage:(MARMessage *)message;
+ (NSString *)cellIndentifier;

@end
