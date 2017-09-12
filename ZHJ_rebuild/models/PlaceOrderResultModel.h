//
//  PlaceOrderResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "PlaceOrderAliPayModel.h"
#import "PlaceOrderWeChatPayModel.h"
#import "PlaceOrderBalanceModel.h"

@interface PlaceOrderResultModel : JSONModel

@property (nonatomic, strong)PlaceOrderAliPayModel *aliPay;
@property (nonatomic, strong)PlaceOrderWeChatPayModel *wxPay;
@property (nonatomic, strong)PlaceOrderBalanceModel<Optional> *balance;

@end
