//
//  GetSpecPriceDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetSpecPriceResultModel.h"

@interface GetSpecPriceDataModel : JSONModel

@property (nonatomic, strong)GetSpecPriceResultModel *result;

@end
