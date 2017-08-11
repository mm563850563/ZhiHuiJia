//
//  MyDiscountCouponResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/10.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MyDiscountCouponNormalModel.h"
#import "MyDiscountCouponExpiredModel.h"
#import "MyDiscountCouponAvailableModel.h"

@protocol MyDiscountCouponNormalModel <NSObject>
@end

@protocol MyDiscountCouponExpiredModel <NSObject>
@end

@protocol MyDiscountCouponAvailableModel <NSObject>
@end

@interface MyDiscountCouponResultModel : JSONModel

@property (nonatomic, strong)NSArray<MyDiscountCouponNormalModel> *normal;
@property (nonatomic, strong)NSArray<MyDiscountCouponExpiredModel> *expired;
@property (nonatomic, strong)NSArray<MyDiscountCouponAvailableModel> *available;

@end
