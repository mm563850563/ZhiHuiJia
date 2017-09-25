//
//  ApplyAfterSaleViewController.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderListGoodsModel;

@interface ApplyAfterSaleViewController : UIViewController

@property (nonatomic, strong)OrderListGoodsModel *modelGoods;
@property (nonatomic, strong)NSString *order_sn;
@property (nonatomic, strong)NSString *order_id;

@end
