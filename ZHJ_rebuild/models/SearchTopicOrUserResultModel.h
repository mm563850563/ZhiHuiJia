//
//  SearchTopicOrUserResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "SearchTopicOrUserTopics_infoModel.h"
#import "SearchTopicOrUserUsers_infoModel.h"

@protocol SearchTopicOrUserTopics_infoModel <NSObject>
@end

@protocol SearchTopicOrUserUsers_infoModel <NSObject>
@end

@interface SearchTopicOrUserResultModel : JSONModel

@property (nonatomic, strong)NSArray<SearchTopicOrUserTopics_infoModel> *topics_info;
@property (nonatomic, strong)NSArray<SearchTopicOrUserUsers_infoModel> *users_info;

@end
