//
//  PlaceOrderBalanceModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/14.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PlaceOrderBalanceModel : JSONModel

//余额支付
@property (nonatomic, strong)NSString<Optional> *payables;
@property (nonatomic, strong)NSString<Optional> *order_sn;
@property (nonatomic, strong)NSString<Optional> *use_money;
@property (nonatomic, strong)NSString<Optional> *coupon_price;
@property (nonatomic, strong)NSString<Optional> *add_time;

@end
