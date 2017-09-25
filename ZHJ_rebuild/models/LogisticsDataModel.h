//
//  LogisticsDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "LogisticsResultModel.h"

@interface LogisticsDataModel : JSONModel

@property (nonatomic, strong)LogisticsResultModel *result;

@end
