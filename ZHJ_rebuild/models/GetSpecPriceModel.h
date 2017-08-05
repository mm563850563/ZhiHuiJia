//
//  GetSpecPriceModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetSpecPriceDataModel.h"

@interface GetSpecPriceModel : JSONModel

@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)GetSpecPriceDataModel *data;

@end
