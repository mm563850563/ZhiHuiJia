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

@interface OrderConfirmResultModel : JSONModel

@property (nonatomic, strong)OrderConfirmGoodsInfoModel *goods_info;
@property (nonatomic, strong)NSString *sub_total;
@property (nonatomic, strong)OrderConfirmUserAddressModel *user_address;

@end
