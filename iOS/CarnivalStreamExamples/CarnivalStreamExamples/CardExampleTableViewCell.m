//
//  TextStandardTableViewCell.m
//  CarnivalStreamExamples
//
//  Created by Sam Jarman on 27/10/15.
//  Copyright © 2015 Carnival Mobile. All rights reserved.
//

#import "CardExampleTableViewCell.h"
#import <DateTools/DateTools.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface CardExampleTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageToTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backingViewToTopConstraint;

@end

@implementation CardExampleTableViewCell

+ (NSString *)cellIndentifier {
    return @"CardExampleTableViewCell";
}

- (void)configureCellWithMessage:(CarnivalMessage *)message atIndexPath:(NSIndexPath *)indexPath {
    [self configureDateLabel:message];
    [self configureUnreadLabel:message];
    [self configureText:message];
    [self configureType:message];
    [self configureImage:message];
    [self configureBackingViewAtIndexPath:indexPath];
}

- (void)configureImage:(CarnivalMessage *)message {
    if (message.imageURL) {
        [self.imgView sd_setImageWithURL:message.imageURL placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.clipsToBounds = YES;
        self.imgHeight.constant = 265.0f;
    }
    else {
        self.imgHeight.constant = 0;
    }
}

- (void)configureImageMask {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imgView.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.imgView.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.imgView.layer.mask = maskLayer;
    self.imgView.layer.frame = self.imgView.bounds;
    self.imgView.layer.masksToBounds = YES;
}

- (void)configureType:(CarnivalMessage *)message {
    switch (message.type) {
        case CarnivalMessageTypeImage:
            self.typeLabel.text = NSLocalizedString(@"Image", nil);
            self.typeImage.image = [UIImage imageNamed:@"image_icon"];
            break;
        case CarnivalMessageTypeVideo:
            self.typeLabel.text =  NSLocalizedString(@"Video", nil);
            self.typeImage.image = [UIImage imageNamed:@"video_icon"];
            break;
        case CarnivalMessageTypeFakeCall:
            self.typeLabel.text = NSLocalizedString(@"Call", nil);
            self.typeImage.image = [UIImage imageNamed:@"video_icon"];
            break;
        case CarnivalMessageTypeLink:
            self.typeLabel.text = NSLocalizedString(@"Link", nil);
            self.typeImage.image = [UIImage imageNamed:@"link_icon"];
            break;
        case CarnivalMessageTypeText:
            self.typeLabel.text = NSLocalizedString(@"Text", nil);
            self.typeImage.image = [UIImage imageNamed:@"text_icon"];
            break;
        default:
            self.typeLabel.text = NSLocalizedString(@"Other", nil);
            self.typeImage.image = [UIImage imageNamed:@"text_icon"];
            break;
    }
}

- (void)configureUnreadLabel:(CarnivalMessage *)message {
    self.unreadLabel.hidden = message.isRead;
    self.unreadLabel.layer.cornerRadius = self.unreadLabel.frame.size.height/2;
    self.unreadLabel.clipsToBounds = YES;
    self.unreadLabel.text = NSLocalizedString(@"Unread", nil);
}

- (void)configureDateLabel:(CarnivalMessage *)message {
    if (message.createdAt) {
        self.timeAgoLabel.text = [NSDate timeAgoSinceDate:message.createdAt];
    }
    else {
        self.timeAgoLabel.text = @"";
    }
}

- (void)configureText:(CarnivalMessage *)message {
    self.titleLabel.text = message.title;
    self.bodyLabel.text = message.text;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        UIColor *backgroundColor = self.unreadLabel.backgroundColor;
        self.unreadLabel.backgroundColor = backgroundColor;
        [self.backingView setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1]];
    }
    else {
        [self.backingView setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)configureBackingViewAtIndexPath:(NSIndexPath *)indexPath {
    self.backingView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.backingView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.backingView.layer.shadowRadius = 1.0;
    self.backingView.layer.shadowOpacity = 0.5;
    
    //For the top cell, we add in some padding, but not to all cells as not to cause double padding.
    if (indexPath.row == 0) {
        self.imageToTopConstraint.constant = 0;
        self.backingViewToTopConstraint.constant = 0;
    }
    else {
        self.imageToTopConstraint.constant = -8;
        self.backingViewToTopConstraint.constant = -8;
    }
    [self setNeedsUpdateConstraints];
}

- (BOOL)preservesSuperviewLayoutMargins {
    return false;
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)separatorInset {
    return UIEdgeInsetsZero;
}

@end