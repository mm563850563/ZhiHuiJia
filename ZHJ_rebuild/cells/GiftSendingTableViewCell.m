//
//  GiftSendingTableViewCell.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "GiftSendingTableViewCell.h"

@implementation GiftSendingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <注册礼按钮响应>
- (IBAction)btnRegisterGiftAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RegisterGiftAction" object:sender];
}

#pragma mark - <分享礼按钮响应>
- (IBAction)btnShareGiftAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ShareGiftAction" object:sender];
}

#pragma mark - <购买礼按钮响应>
- (IBAction)btnBuyGiftAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"BuyGiftAction" object:sender];
}


@end
