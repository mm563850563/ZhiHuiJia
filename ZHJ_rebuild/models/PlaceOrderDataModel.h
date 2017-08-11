//
//  PlaceOrderDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PlaceOrderResultModel.h"

@interface PlaceOrderDataModel : JSONModel

@property (nonatomic, strong)PlaceOrderResultModel *result;

@end
