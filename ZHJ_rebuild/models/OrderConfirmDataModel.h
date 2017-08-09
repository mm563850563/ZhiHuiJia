//
//  OrderConfirmDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/9.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OrderConfirmResultModel.h"

@interface OrderConfirmDataModel : JSONModel

@property (nonatomic, strong)OrderConfirmResultModel *result;

@end
