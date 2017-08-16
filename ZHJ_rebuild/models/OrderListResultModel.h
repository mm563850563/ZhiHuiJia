//
//  OrderListResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/16.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OrderList_OrderListModel.h"

@protocol OrderList_OrderListModel <NSObject>
@end

@interface OrderListResultModel : JSONModel

@property (nonatomic, strong)NSString *page;
@property (nonatomic, strong)NSArray<OrderList_OrderListModel> *order_list;

@end
