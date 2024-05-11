//
//  GraphicalCardTableViewCell.h
//  MarigoldStreamExamples
//
//  Created by Sam Jarman on 9/09/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Marigold/Marigold.h>
#import "TextCardTableViewCell.h"

@interface GraphicalCardTableViewCell : TextCardTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
