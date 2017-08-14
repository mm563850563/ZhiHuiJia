//
//  PlaceOrderWeChatPayModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/14.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "PlaceOrderCallbackModel.h"
#import "PalceOrderOrderInfoModel.h"

@interface PlaceOrderWeChatPayModel : JSONModel

@property (nonatomic, strong)PalceOrderOrderInfoModel *order_info;
@property (nonatomic, strong)PlaceOrderCallbackModel *callback;

@end
