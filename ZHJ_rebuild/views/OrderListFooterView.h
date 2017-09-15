//
//  OrderListFooterView.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderList_OrderListModel.h"

@interface OrderListFooterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *labelProductCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;

@property (nonatomic, strong)OrderList_OrderListModel *modelOrderList;

@property (nonatomic, strong)NSString *whereReuseFrom;

@end
