//
//  BasicTableViewCell.h
//  MarigoldStreamExamples
//
//  Created by Sam Jarman on 11/08/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Marigold/Marigold.h>

@interface ListStreamTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

- (void)configureCellWithMessage:(MARMessage *)message;

+ (NSString *)cellIndentifier;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageOffset;

@end
