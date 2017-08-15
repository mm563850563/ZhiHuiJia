//
//  PlaceOrderCallbackModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/14.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PlaceOrderCallbackModel : JSONModel

//微信支付
@property (nonatomic, strong)NSString *appid;
@property (nonatomic, strong)NSString *noncestr;
@property (nonatomic, strong)NSString *package;
@property (nonatomic, strong)NSString *partnerid;
@property (nonatomic, strong)NSString *prepayid;
@property (nonatomic, strong)NSString *timestamp;
@property (nonatomic, strong)NSString<Optional> *sign;

@end
