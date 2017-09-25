//
//  AfterSalesHeaderView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "AfterSalesHeaderView.h"

#import "AfterSaleListResultModel.h"

@interface AfterSalesHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *labelProductCode;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@end

@implementation AfterSalesHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setModelAfterSaleResult:(AfterSaleListResultModel *)modelAfterSaleResult
{
    _modelAfterSaleResult = modelAfterSaleResult;
    
    self.labelProductCode.text = [NSString stringWithFormat:@"%@",modelAfterSaleResult.order_sn];
    
    double timeInterval = [modelAfterSaleResult.addtime doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateStr = [formatter stringFromDate:date];
    
    self.labelTime.text = [NSString stringWithFormat:@"%@",dateStr];
}








@end
