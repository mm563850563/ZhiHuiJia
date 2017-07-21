//
//  LookAroundCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "LookAroundCell.h"

@implementation LookAroundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)drawRect:(CGRect)rect
{
    CGFloat round = self.imgView.frame.size.width/2.0;
    self.imgView.layer.cornerRadius = round;
    self.imgView.layer.masksToBounds = YES;
}

@end
