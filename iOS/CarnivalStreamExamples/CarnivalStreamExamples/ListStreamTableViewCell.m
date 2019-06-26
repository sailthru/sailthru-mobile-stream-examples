//
//  BasicTableViewCell.m
//  CarnivalStreamExamples
//
//  Created by Sam Jarman on 11/08/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

#import "ListStreamTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <DateTools.h>
#import "ScreenSizeHelper.h"

@implementation ListStreamTableViewCell

- (void)configureCellWithMessage:(CarnivalMessage *)message {
    
    [self configureDateLabel:message];
    [self configureUnreadLabel:message];
    [self configureTitleLabel:message];
    [self configureType:message];
    [self configureImage:message];
    
}

- (void)configureImage:(CarnivalMessage *)message {
    //Configure the Asynchronous Image View
    if (message.imageURL) {
        [self.imgView sd_setImageWithURL:message.imageURL placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.clipsToBounds = YES;
        self.imageOffset.constant = 0;
    }
    else {
        // hide the image
        self.imageOffset.constant = IS_IPHONE_5_OR_LESS ? -90 : -110;
    }
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
        case CarnivalMessageTypeStandardPush:
            self.typeLabel.text = NSLocalizedString(@"Text", nil);
            self.typeImage.image = [UIImage imageNamed:@"text_icon"];
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
    
    CGFloat fontSize = IS_IPHONE_5_OR_LESS ? TEXT_SMALL : TEXT_NORMAL;
    self.typeLabel.font = [UIFont systemFontOfSize:fontSize];
    
}

- (void)configureUnreadLabel:(CarnivalMessage *)message {
    self.unreadLabel.hidden = message.isRead;
    self.unreadLabel.layer.cornerRadius = self.unreadLabel.frame.size.height/2;
    self.unreadLabel.clipsToBounds = YES;
    self.unreadLabel.text = NSLocalizedString(@"Unread", nil);
    CGFloat fontSize = IS_IPHONE_5_OR_LESS ? TEXT_SMALL : TEXT_NORMAL;
    self.unreadLabel.font = [UIFont systemFontOfSize:fontSize];
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

- (void)configureTitleLabel:(CarnivalMessage *)message {
    CGFloat fontSize = IS_IPHONE_5_OR_LESS ? 15 : 18;
    self.titleTextView.textContainerInset = UIEdgeInsetsZero;
    self.titleTextView.textContainer.lineFragmentPadding = 0;
    self.titleTextView.text = message.title;
    self.titleTextView.textColor = [UIColor colorWithRed:26./255 green:150./255 blue:226./255 alpha:1];
    self.titleTextView.font = [UIFont boldSystemFontOfSize:fontSize];
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

- (BOOL)preservesSuperviewLayoutMargins {
    return false;
}

+ (NSString *)cellIndentifier {
    return @"ListStreamTableViewCell";
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

@end
