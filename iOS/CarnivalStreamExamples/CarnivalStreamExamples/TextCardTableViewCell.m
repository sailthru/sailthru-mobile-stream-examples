//
//  TextCardTableViewCell.m
//  CarnivalStreamExamples
//
//  Created by Sam Jarman on 9/09/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

#import "TextCardTableViewCell.h"
#import "ScreenSizeHelper.h"
#import "UILabel+HTML.h"
#import <DateTools.h>

@interface TextCardTableViewCell()
@property (nonatomic, strong) CAGradientLayer *gradient;

@end

@implementation TextCardTableViewCell
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.gradient = [[CAGradientLayer alloc] init];
    }
    return self;
}

- (void)configureCellWithMessage:(CarnivalMessage *)message {
    self.titleLabel.text = message.title;
    [self.bodyLabel setHTMLFromString:message.htmlText];
    [self configureDateLabel:message];
    [self configureUnreadLabel:message];
    
    if (!message.imageURL) {
        [self configureGradient];
    }
}

- (void)configureDateLabel:(CarnivalMessage *)message {
    if (message.createdAt) {
        self.timeAgoLabel.text = [NSDate timeAgoSinceDate:message.createdAt];
    }
    else {
        self.timeAgoLabel.text = @"";
    }
    CGFloat fontSize = IS_IPHONE_5_OR_LESS ? TEXT_SMALL : TEXT_NORMAL;
    self.timeAgoLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)configureUnreadLabel:(CarnivalMessage *)message {
    self.unreadLabel.hidden = message.isRead;
    self.unreadLabel.layer.cornerRadius = self.unreadLabel.frame.size.height/2;
    self.unreadLabel.clipsToBounds = YES;
    CGFloat fontSize = IS_IPHONE_5_OR_LESS ? TEXT_SMALL : TEXT_NORMAL;
    self.unreadLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)configureGradient {
    _gradient.frame = self.contentView.bounds;
    _gradient.startPoint = CGPointMake(0.1, 0.0);
    _gradient.endPoint = CGPointMake(0.9,1);

    _gradient.colors = @[
                         (id)[UIColor colorWithRed:106.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1].CGColor,
                         (id)[UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1].CGColor
                        ];
    [self.contentView.layer insertSublayer:self.gradient atIndex:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *backgroundColor = self.unreadLabel.backgroundColor;
    [super setSelected:selected animated:animated];
    self.unreadLabel.backgroundColor = backgroundColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    UIColor *backgroundColor = self.unreadLabel.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.unreadLabel.backgroundColor = backgroundColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradient.frame = self.contentView.bounds;
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

+ (NSString *)cellIndentifier {
    return @"TextCardTableViewCell";
}

@end