//
//  TextCardTableViewCell.h
//  CarnivalStreamExamples
//
//  Created by Sam Jarman on 9/09/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Carnival/Carnival.h>
#import "CarnivalLabel.h"

@interface TextCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CarnivalLabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;
- (void)configureCellWithMessage:(CarnivalMessage *)message;
+ (NSString *)cellIndentifier;

@end
