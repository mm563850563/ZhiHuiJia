//
//  PalceOrderOrderInfoModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/14.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PalceOrderOrderInfoModel : JSONModel

@property (nonatomic, strong)NSString *payables;
@property (nonatomic, strong)NSString *order_sn;
@property (nonatomic, strong)NSString *use_money;
@property (nonatomic, strong)NSString *coupon_price;
@property (nonatomic, strong)NSString *add_time;

@end
