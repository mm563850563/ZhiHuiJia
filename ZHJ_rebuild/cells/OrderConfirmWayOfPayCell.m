//
//  OrderConfirmWayOfPayCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "OrderConfirmWayOfPayCell.h"



@interface OrderConfirmWayOfPayCell ()

@end

@implementation OrderConfirmWayOfPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)drawRect:(CGRect)rect
{
    self.checkBox = [[SSCheckBoxView alloc]initWithFrame:self.checkboxBGView.bounds style:kSSCheckBoxViewStyleGreen checked:YES];
    [self.checkboxBGView addSubview:self.checkBox];
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.checkBox.checked = YES;
    }else{
        self.checkBox.checked = NO;
    }
}

@end
