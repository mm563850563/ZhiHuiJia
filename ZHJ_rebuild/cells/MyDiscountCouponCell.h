//
//  MyDiscountCouponCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/10.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyDiscountCouponAvailableModel;
@class MyDiscountCouponNormalModel;
@class MyDiscountCouponExpiredModel;
@class MyDiscountCouponUsedModel;

@interface MyDiscountCouponCell : UITableViewCell

@property (nonatomic, strong)MyDiscountCouponAvailableModel *modelAvailable;
@property (nonatomic, strong)MyDiscountCouponNormalModel *modelNormal;
@property (nonatomic, strong)MyDiscountCouponExpiredModel *modelExpired;
@property (nonatomic, strong)MyDiscountCouponUsedModel *modelUsed;

@end
