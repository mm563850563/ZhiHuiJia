//
//  DiscoverHeaderCell.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/12.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DiscoverHeaderCell.h"

@implementation DiscoverHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - <点击圈子响应>
- (IBAction)btnCircleAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickCircleAction" object:nil];
}

#pragma mark - <点击同城响应>
- (IBAction)btnSameTownAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickSameTownAction" object:nil];
}

#pragma mark - <点击地盘响应>
- (IBAction)btnDomainAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickDomainAction" object:nil];
}

@end
