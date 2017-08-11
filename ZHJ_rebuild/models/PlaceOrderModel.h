//
//  PlaceOrderModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PlaceOrderDataModel.h"

@interface PlaceOrderModel : JSONModel

@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)PlaceOrderDataModel *data;

@end
