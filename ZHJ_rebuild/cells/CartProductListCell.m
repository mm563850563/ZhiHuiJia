//
//  CartProductListCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/14.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CartProductListCell.h"

//views
#import "SSCheckBoxView.h"

@implementation CartProductListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.checkBox = [[SSCheckBoxView alloc]initWithFrame:self.checkBoxBGView.bounds style:kSSCheckBoxViewStyleGreen checked:YES];
    [self.checkBoxBGView addSubview:self.checkBox];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
