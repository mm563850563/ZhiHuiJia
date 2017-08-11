//
//  MyDiscountCouponDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/10.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MyDiscountCouponResultModel.h"

@interface MyDiscountCouponDataModel : JSONModel

@property (nonatomic, strong)MyDiscountCouponResultModel *result;

@end
