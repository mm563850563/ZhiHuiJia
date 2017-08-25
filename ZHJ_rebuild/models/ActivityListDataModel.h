//
//  ActivityListDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/24.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ActivityListResultModel.h"

@protocol ActivityListResultModel <NSObject>
@end

@interface ActivityListDataModel : JSONModel

@property (nonatomic, strong)NSArray<ActivityListResultModel> *result;

@end
