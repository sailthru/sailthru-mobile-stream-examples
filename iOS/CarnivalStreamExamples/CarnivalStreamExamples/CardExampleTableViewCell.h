//
//  TextStandardTableViewCell.h
//  CarnivalStreamExamples
//
//  Created by Sam Jarman on 27/10/15.
//  Copyright © 2015 Carnival Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Carnival/Carnival.h>
#import "CarnivalLabel.h"

@interface CardExampleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CarnivalLabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet UIView *backingView;

- (void)configureCellWithMessage:(CarnivalMessage *)message atIndexPath:(NSIndexPath *)indexPath;

+ (NSString *)cellIndentifier;

@end
