//
//  MyDiscountCouponCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/10.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyDiscountCouponCell.h"
#import "MyDiscountCouponAvailableModel.h"

@interface MyDiscountCouponCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelMoney;
@property (weak, nonatomic) IBOutlet UILabel *labelCondition;
@property (weak, nonatomic) IBOutlet UILabel *labelMoneyCoupon;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeLimit;

@end

@implementation MyDiscountCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModelAvailable:(MyDiscountCouponAvailableModel *)modelAvailable
{
    self.labelMoney.text = modelAvailable.money;
    self.labelMoneyCoupon.text = [NSString stringWithFormat:@"%@元代金券",modelAvailable.money];
    self.labelCondition.text = [NSString stringWithFormat:@"满%@可用",modelAvailable.condition];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval timeFrom = [modelAvailable.send_time doubleValue]+28800;
    NSTimeInterval timeTo = [modelAvailable.end_time doubleValue]+28800;
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:timeFrom];
    NSDate *dateTo = [NSDate dateWithTimeIntervalSince1970:timeTo];
    NSString *strDateFrom = [formatter stringFromDate:dateFrom];
    NSString *strDateTo = [formatter stringFromDate:dateTo];
    self.labelTimeLimit.text = [NSString stringWithFormat:@"%@至%@",strDateFrom,strDateTo];
    
    
}





@end
