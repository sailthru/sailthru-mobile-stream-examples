//
//  GraphicalCardTableViewCell.m
//  MarigoldStreamExamples
//
//  Created by Sam Jarman on 9/09/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
//

#import "GraphicalCardTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GraphicalCardTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *timeBackground;

@end

@implementation GraphicalCardTableViewCell

- (void)configureCellWithMessage:(MARMessage *)message {
    [super configureCellWithMessage:message];
    [self configureTimeBackground];
    if (message.imageURL) {
        [self.imgView sd_setImageWithURL:message.imageURL placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.clipsToBounds = YES;
    }
}

+ (NSString *)cellIndentifier {
    return @"GraphicalCardTableViewCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *backgroundColor = self.timeBackground.backgroundColor;
    [super setSelected:selected animated:animated];
    self.timeBackground.backgroundColor = backgroundColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    UIColor *backgroundColor = self.timeBackground.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.timeBackground.backgroundColor = backgroundColor;
}

- (void)configureTimeBackground {
    self.timeBackground.layer.cornerRadius = 4.0;
}

@end
