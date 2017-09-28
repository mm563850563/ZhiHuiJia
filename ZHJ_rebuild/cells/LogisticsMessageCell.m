//
//  LogisticsMessageCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "LogisticsMessageCell.h"

#import "LogisticsResultModel.h"

@interface LogisticsMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelLogisticsStatus;
@property (weak, nonatomic) IBOutlet UILabel *labellogisticsCompany;
@property (weak, nonatomic) IBOutlet UILabel *labelLogisticsCode;
@property (weak, nonatomic) IBOutlet UIButton *btnMobile;

@end

@implementation LogisticsMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelLogisticsResult:(LogisticsResultModel *)modelLogisticsResult
{
    _modelLogisticsResult = modelLogisticsResult;
    
    NSString *state = [NSString string];
    if ([modelLogisticsResult.state isEqualToString:@"0"]) {
        state = @"运输中";
    }else if ([modelLogisticsResult.state isEqualToString:@"1"]){
        state = @"已揽件";
    }else if ([modelLogisticsResult.state isEqualToString:@"2"]){
        state = @"物流异常";
    }else if ([modelLogisticsResult.state isEqualToString:@"3"]){
        state = @"已签收";
    }else if ([modelLogisticsResult.state isEqualToString:@"4"]){
        state = @"已退签";
    }else if ([modelLogisticsResult.state isEqualToString:@"5"]){
        state = @"派件中";
    }else if ([modelLogisticsResult.state isEqualToString:@"6"]){
        state = @"退回中";
    }
    self.labelLogisticsStatus.text = state;
    self.labellogisticsCompany.text = modelLogisticsResult.com;
    self.labelLogisticsCode.text = modelLogisticsResult.nu;
    [self.btnMobile setTitle:@"020-34761998 (转305)" forState:UIControlStateNormal];
}

- (IBAction)btnMobileAction:(UIButton *)sender
{
    NSArray *array = [sender.titleLabel.text componentsSeparatedByString:@" "];
    NSString *phoneStr = array[0];
    
    if (![phoneStr isEqualToString:@""]) {
        NSMutableString *str = [NSMutableString stringWithFormat:@"tel:%@",phoneStr];
        NSURL *url = [NSURL URLWithString:str];
        
        [[UIApplication sharedApplication]openURL:url];
    }
}


@end
