//
//  GetHotCycleDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetHotCycleResultModel.h"

@protocol GetHotCycleResultModel <NSObject>
@end

@interface GetHotCycleDataModel : JSONModel

@property (nonatomic, strong)NSArray<GetHotCycleResultModel> *result;

@end
