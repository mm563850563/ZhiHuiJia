//
//  MyDiscountCouponCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/10.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyDiscountCouponCell.h"
#import "MyDiscountCouponAvailableModel.h"
#import "MyDiscountCouponNormalModel.h"
#import "MyDiscountCouponExpiredModel.h"
#import "MyDiscountCouponUsedModel.h"

@interface MyDiscountCouponCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelMoney;
@property (weak, nonatomic) IBOutlet UILabel *labelCondition;
@property (weak, nonatomic) IBOutlet UILabel *labelMoneyCoupon;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeLimit;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGColor;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;

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
    NSTimeInterval timeFrom = [modelAvailable.send_time doubleValue];
    NSTimeInterval timeTo = [modelAvailable.end_time doubleValue];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:timeFrom];
    NSDate *dateTo = [NSDate dateWithTimeIntervalSince1970:timeTo];
    NSString *strDateFrom = [formatter stringFromDate:dateFrom];
    NSString *strDateTo = [formatter stringFromDate:dateTo];
    self.labelTimeLimit.text = [NSString stringWithFormat:@"%@至%@",strDateFrom,strDateTo];
}

-(void)setModelNormal:(MyDiscountCouponNormalModel *)modelNormal
{
    self.labelMoney.text = modelNormal.money;
    self.labelMoneyCoupon.text = [NSString stringWithFormat:@"%@元代金券",modelNormal.money];
    self.labelCondition.text = [NSString stringWithFormat:@"满%@可用",modelNormal.condition];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval timeFrom = [modelNormal.send_time doubleValue];
    NSTimeInterval timeTo = [modelNormal.end_time doubleValue];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:timeFrom];
    NSDate *dateTo = [NSDate dateWithTimeIntervalSince1970:timeTo];
    NSString *strDateFrom = [formatter stringFromDate:dateFrom];
    NSString *strDateTo = [formatter stringFromDate:dateTo];
    self.labelTimeLimit.text = [NSString stringWithFormat:@"%@至%@",strDateFrom,strDateTo];
}

-(void)setModelExpired:(MyDiscountCouponExpiredModel *)modelExpired
{
    self.labelMoney.text = modelExpired.money;
    self.labelMoneyCoupon.text = [NSString stringWithFormat:@"%@元代金券",modelExpired.money];
    self.labelCondition.text = [NSString stringWithFormat:@"满%@可用",modelExpired.condition];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval timeFrom = [modelExpired.send_time doubleValue];
    NSTimeInterval timeTo = [modelExpired.end_time doubleValue];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:timeFrom];
    NSDate *dateTo = [NSDate dateWithTimeIntervalSince1970:timeTo];
    NSString *strDateFrom = [formatter stringFromDate:dateFrom];
    NSString *strDateTo = [formatter stringFromDate:dateTo];
    self.labelTimeLimit.text = [NSString stringWithFormat:@"%@至%@",strDateFrom,strDateTo];
    
    self.imgStatus.image = [UIImage imageNamed:@"discountExpired"];
}

-(void)setModelUsed:(MyDiscountCouponUsedModel *)modelUsed
{
    self.labelMoney.text = modelUsed.money;
    self.labelMoneyCoupon.text = [NSString stringWithFormat:@"%@元代金券",modelUsed.money];
    self.labelCondition.text = [NSString stringWithFormat:@"满%@可用",modelUsed.condition];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval timeFrom = [modelUsed.send_time doubleValue];
    NSTimeInterval timeTo = [modelUsed.end_time doubleValue];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:timeFrom];
    NSDate *dateTo = [NSDate dateWithTimeIntervalSince1970:timeTo];
    NSString *strDateFrom = [formatter stringFromDate:dateFrom];
    NSString *strDateTo = [formatter stringFromDate:dateTo];
    self.labelTimeLimit.text = [NSString stringWithFormat:@"%@至%@",strDateFrom,strDateTo];
    
    self.imgStatus.image = [UIImage imageNamed:@"discountUsed"];
}



@end
