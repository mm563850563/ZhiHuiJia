//
//  MyDiscountCouponUsedModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/16.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MyDiscountCouponUsedModel : JSONModel

@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *condition;
@property (nonatomic, strong)NSString *money;
@property (nonatomic, strong)NSString *send_time;
@property (nonatomic, strong)NSString *end_time;
@property (nonatomic, strong)NSString *use_time;

@end
