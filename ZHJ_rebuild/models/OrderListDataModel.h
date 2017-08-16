//
//  OrderListDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/16.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OrderListResultModel.h"

@interface OrderListDataModel : JSONModel

@property (nonatomic, strong)OrderListResultModel *result;

@end
