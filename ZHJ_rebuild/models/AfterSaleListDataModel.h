//
//  AfterSaleListDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AfterSaleListResultModel.h"

@protocol AfterSaleListResultModel <NSObject>
@end

@interface AfterSaleListDataModel : JSONModel

@property (nonatomic, strong)NSArray<AfterSaleListResultModel,Optional> *result;

@end
