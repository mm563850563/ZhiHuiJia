//
//  TopicDetailDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/2.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "TopicDetailResultModel.h"

@interface TopicDetailDataModel : JSONModel

@property (nonatomic, strong)TopicDetailResultModel *result;

@end
