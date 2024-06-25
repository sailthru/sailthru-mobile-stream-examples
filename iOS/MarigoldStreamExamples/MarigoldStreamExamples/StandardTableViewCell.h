//
//  TextStandardTableViewCell.h
//  MarigoldStreamExamples
//
//  Created by Sam Jarman on 27/10/15.
//  Copyright © 2015 Marigold Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Marigold/Marigold.h>
#import "MarigoldLabel.h"

@interface StandardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MarigoldLabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet UIView *backingView;

- (void)configureCellWithMessage:(MARMessage *)message;

+ (NSString *)cellIndentifier;

@end
