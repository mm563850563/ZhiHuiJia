//
//  PersonalLivenessRankDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/1.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PersonalLivenessRankResultModel.h"

@interface PersonalLivenessRankDataModel : JSONModel

@property (nonatomic, strong)PersonalLivenessRankResultModel *result;

@end
