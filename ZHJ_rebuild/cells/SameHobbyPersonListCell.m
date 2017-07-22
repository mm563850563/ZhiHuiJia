//
//  SameHobbyPersonListCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SameHobbyPersonListCell.h"

@implementation SameHobbyPersonListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <点击关注按钮响应>
- (IBAction)btnOnFocusAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

@end
