//
//  MyAddressCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyAddressCell.h"

@implementation MyAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <删除地址>
- (IBAction)btnDeleteAddressAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DeleteAddressAction" object:sender];
}

#pragma mark - <编辑地址>
- (IBAction)btnEditAddressAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EditAddressAction" object:sender];
}




@end
