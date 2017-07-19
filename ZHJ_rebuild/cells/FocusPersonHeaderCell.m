//
//  FocusPersonHeaderCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "FocusPersonHeaderCell.h"

@implementation FocusPersonHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <返回按钮响应>
- (IBAction)btnGoBackAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"popFocusPersonHeaderVC" object:nil];
}

#pragma mark - <+关注按钮响应>
- (IBAction)btnOnFocusAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickOnFocus" object:nil];
}

#pragma mark - <私信按钮响应>
- (IBAction)btnPrivateChatAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickPrivateChat" object:nil];
}

#pragma mark - <个人活跃度排名按钮响应>
- (IBAction)btnPersonActivitySortAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickPersonActivitySort" object:nil];
}

@end
