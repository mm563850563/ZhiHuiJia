//
//  GetUserPrizeDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/3.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetUserPrizeResultModel.h"

@interface GetUserPrizeDataModel : JSONModel

@property (nonatomic, strong)GetUserPrizeResultModel *result;

@end
