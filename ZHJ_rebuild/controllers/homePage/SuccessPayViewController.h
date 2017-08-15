//
//  SuccessPayViewController.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlaceOrderAliPayModel.h"
#import "PalceOrderOrderInfoModel.h"

@interface SuccessPayViewController : UIViewController

@property (nonatomic, strong)PlaceOrderAliPayModel *modelAli;
@property (nonatomic, strong)PalceOrderOrderInfoModel *modelWX;

@end
