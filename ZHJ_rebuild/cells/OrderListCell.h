//
//  OrderListCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderListGoodsModel.h"

@interface OrderListCell : UITableViewCell

@property (nonatomic, strong)OrderListGoodsModel *modelGoods;
@property (nonatomic ,strong)NSString *whereReuseFrom;
@property (nonatomic, strong)NSString *order_sn;
@property (nonatomic, strong)NSString *order_id;

@end
