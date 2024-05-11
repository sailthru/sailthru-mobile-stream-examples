//
//  MarigoldLabel.m
//  MarigoldStreamExamples
//
//  Created by Sam Jarman on 7/09/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
//

#import "MarigoldLabel.h"

@implementation MarigoldLabel

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    // If this is a multiline label, need to make sure
    // preferredMaxLayoutWidth always matches the frame width
    // (i.e. orientation change can mess this up)
    
    if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self invalidateIntrinsicContentSize];
    }
}

@end
