//
//  HotTopicListDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "HotTopicListResultModel.h"

@protocol HotTopicListResultModel <NSObject>
@end

@interface HotTopicListDataModel : JSONModel

@property (nonatomic, strong)NSArray<HotTopicListResultModel> *result;

@end
