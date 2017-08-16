//
//  OrderList_OrderListModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/16.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OrderListGoodsModel.h"

@protocol OrderListGoodsModel <NSObject>
@end

@interface OrderList_OrderListModel : JSONModel

@property (nonatomic, strong)NSString *order_id;
@property (nonatomic, strong)NSString *order_sn;
@property (nonatomic, strong)NSString *goods_price;
@property (nonatomic, strong)NSString *freight;
@property (nonatomic, strong)NSArray<OrderListGoodsModel> *goods;
@property (nonatomic, strong)NSString *goods_count;
@property (nonatomic, strong)NSString *order_status_desc;

@end
