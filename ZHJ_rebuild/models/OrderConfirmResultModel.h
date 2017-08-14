//
//  OrderConfirmResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/9.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OrderConfirmGoodsInfoModel.h"
#import "OrderConfirmUserAddressModel.h"

@protocol OrderConfirmGoodsInfoModel <NSObject>
@end

@interface OrderConfirmResultModel : JSONModel

@property (nonatomic, strong)NSArray<OrderConfirmGoodsInfoModel> *goods_info;
@property (nonatomic, strong)NSString *unpaid;
@property (nonatomic, strong)OrderConfirmUserAddressModel *user_address;
@property (nonatomic, strong)NSString *freight;
@property (nonatomic, strong)NSString *total_price;
@property (nonatomic, strong)NSString *use_money;

@end
