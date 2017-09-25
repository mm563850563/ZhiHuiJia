//
//  LogisticsResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "LogisticsRealTimeModel.h"

@protocol LogisticsRealTimeModel <NSObject>
@end

@interface LogisticsResultModel : JSONModel

@property (nonatomic, strong)NSString<Optional> *message;
@property (nonatomic, strong)NSString<Optional> *nu;
@property (nonatomic, strong)NSString<Optional> *ischeck;
@property (nonatomic, strong)NSString<Optional> *condition;
@property (nonatomic, strong)NSString<Optional> *com;
@property (nonatomic, strong)NSString<Optional> *status;
@property (nonatomic, strong)NSString<Optional> *state;
@property (nonatomic, strong)NSArray<LogisticsRealTimeModel,Optional> *data;

@end
