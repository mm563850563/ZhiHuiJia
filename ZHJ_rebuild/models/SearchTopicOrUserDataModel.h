//
//  SearchTopicOrUserDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "SearchTopicOrUserResultModel.h"

@interface SearchTopicOrUserDataModel : JSONModel

@property (nonatomic, strong)SearchTopicOrUserResultModel *result;

@end
