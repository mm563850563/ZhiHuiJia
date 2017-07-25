//
//  BrandDetailHeaderCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "BrandDetailHeaderCell.h"

@implementation BrandDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.imgProduct mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200);
    }];
}

@end
