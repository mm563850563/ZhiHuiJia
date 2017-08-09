//
//  OrderConfirmModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/9.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OrderConfirmDataModel.h"

@interface OrderConfirmModel : JSONModel

@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)OrderConfirmDataModel *data;

@end
