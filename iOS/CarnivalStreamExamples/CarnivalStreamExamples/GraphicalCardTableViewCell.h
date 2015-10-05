//
//  GraphicalCardTableViewCell.h
//  CarnivalStreamExamples
//
//  Created by Sam Jarman on 9/09/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Carnival/Carnival.h>
#import "TextCardTableViewCell.h"

@interface GraphicalCardTableViewCell : TextCardTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
