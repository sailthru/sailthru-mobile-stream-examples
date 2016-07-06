//
//  UILabel+HTML.m
//  CarnivalStreamExamples
//
//  Created by Affian on 5/07/16.
//  Copyright © 2016 Carnival Mobile. All rights reserved.
//

#import "UILabel+HTML.h"

@implementation UILabel (HTML)

- (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

- (void)setHTMLFromString:(NSString *)string {
    string = [string stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx; color: %@;}</style>",
                                              self.font.fontName,
                                              self.font.pointSize,
                                              [self hexStringFromColor: self.textColor]]];
    
    self.attributedText = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding]
                                                           options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                     NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                documentAttributes:nil
                                                             error:nil];
}

@end
