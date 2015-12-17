//
//  TextStandardTableViewCell.m
//  CarnivalStreamExamples
//
//  Created by Sam Jarman on 27/10/15.
//  Copyright © 2015 Carnival Mobile. All rights reserved.
//

#import "StandardTableViewCell.h"
#import <DateTools/DateTools.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation StandardTableViewCell

+ (NSString *)cellIndentifier {
    return @"StandardTableViewCell";
}

- (void)configureCellWithMessage:(CarnivalMessage *)message {
    [self configureDateLabel:message];
    [self configureUnreadLabel:message];
    [self configureText:message];
    [self configureType:message];
    [self configureImage:message];
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
    [self invalidateIntrinsicContentSize];
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
        [self.backingView setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1]];
    }
    else {
        [self.backingView setBackgroundColor:[UIColor whiteColor]];
    }
}

- (BOOL)preservesSuperviewLayoutMargins {
    return NO;
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

@end
