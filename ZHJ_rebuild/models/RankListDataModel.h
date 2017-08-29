//
//  RankListDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "RankListResultModel.h"

@interface RankListDataModel : JSONModel

@property (nonatomic, strong)RankListResultModel *result;

@end
