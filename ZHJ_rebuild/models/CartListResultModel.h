//
//  CartListResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/5.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CartList_CartListModel.h"
#import "CartListTotalPriceModel.h"

@protocol CartList_CartListModel <NSObject>
@end

@interface CartListResultModel : JSONModel

@property (nonatomic, strong)NSArray<CartList_CartListModel> *cart_list;
@property (nonatomic, strong)CartListTotalPriceModel *total_price;

@end
