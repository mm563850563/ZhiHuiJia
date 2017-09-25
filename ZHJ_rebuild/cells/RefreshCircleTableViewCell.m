//
//  RefreshCircleTableViewCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/23.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "RefreshCircleTableViewCell.h"

@interface RefreshCircleTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnRefreshCircle;

@end

@implementation RefreshCircleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect
{
    [self settingOutlets];
}

-(void)settingOutlets
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"换一批"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [self.btnRefreshCircle setAttributedTitle:str forState:UIControlStateNormal];
    self.btnRefreshCircle.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btnRefreshCircle.titleLabel.textColor = kColorFromRGB(kDeepGray);
}

@end
