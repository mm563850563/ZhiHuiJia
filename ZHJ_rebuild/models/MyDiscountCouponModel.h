//
//  MyDiscountCouponModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/10.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MyDiscountCouponDataModel.h"

@interface MyDiscountCouponModel : JSONModel

@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)MyDiscountCouponDataModel *data;

@end
