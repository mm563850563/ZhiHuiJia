//
//  HotTopicListResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HotTopicListResultModel : JSONModel

@property (nonatomic, strong)NSString *topic_id;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *reply_count;
@property (nonatomic, strong)NSString *like_count;

@end
