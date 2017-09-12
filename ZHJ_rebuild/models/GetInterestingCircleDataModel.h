//
//  GetInterestingCircleDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/12.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetInterestingCircleResultModel.h"

@protocol GetInterestingCircleResultModel <NSObject>
@end

@interface GetInterestingCircleDataModel : JSONModel

@property (nonatomic, strong)NSArray<GetInterestingCircleResultModel> *result;

@end
