//
//  TopicDetailResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/2.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TopicDetailResultModel : JSONModel

@property (nonatomic, strong)NSString *topic_id;
@property (nonatomic, strong)NSString *topic_title;
@property (nonatomic, strong)NSString *banner;
@property (nonatomic, strong)NSString *news;

@end
