//
//  RoundedButton.m
//  
//
//  Created by Adam Jones on 18/09/15.
//
//

#import "RoundedButton.h"

@implementation RoundedButton

- (void)drawRect:(CGRect)rect {
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 22.5, 0, 22.5);

    UIImage *buttonBg = [[UIImage imageNamed:@"button_bg"] resizableImageWithCapInsets:insets];
    UIImage *buttonBgPressed = [[UIImage imageNamed:@"button_bg_pressed"] resizableImageWithCapInsets:insets];

    [self setBackgroundImage:buttonBg forState:UIControlStateNormal];
    [self setBackgroundImage:buttonBgPressed forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

}

@end
