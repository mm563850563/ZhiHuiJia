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
    
    [self addCheckBox];
}

-(void)addCheckBox
{
    BOOL checked;
    if ([self.wayOfPay isEqualToString:@"0"]) {
        checked = YES;
    }else{
        checked = NO;
    }
    self.checkBox = [[SSCheckBoxView alloc]initWithFrame:self.checkboxBGView.bounds style:kSSCheckBoxViewStyleGreen checked:checked];
    [self.checkboxBGView addSubview:self.checkBox];
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
//        NSLog(@"%ld",(long)self.tag);
        self.checkBox.checked = YES;
    }else{
//        NSLog(@"%ld",(long)self.tag);
        self.checkBox.checked = NO;
    }
}

@end
