//
//  ActivityRecommendImageCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ActivityRecommendImageCell.h"

@implementation ActivityRecommendImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <"我要报名"响应>
- (IBAction)btnApplyAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"applyAction" object:nil];
}


@end
