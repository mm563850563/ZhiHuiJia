//
//  OrderListModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/16.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OrderListDataModel.h"

@interface OrderListModel : JSONModel

@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)OrderListDataModel *data;

@end
