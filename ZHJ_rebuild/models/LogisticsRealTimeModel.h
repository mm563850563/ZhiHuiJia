//
//  LogisticsRealTimeModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LogisticsRealTimeModel : JSONModel

@property (nonatomic, strong)NSString *time;
@property (nonatomic, strong)NSString *ftime;
@property (nonatomic, strong)NSString *context;
@property (nonatomic, strong)NSString *location;

@end
