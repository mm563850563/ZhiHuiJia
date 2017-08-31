//
//  DynamicDetailCommentResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DynamicDetailCommentResultModel : JSONModel

@property (nonatomic, strong)NSString *talk_id;
@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *tips;
@property (nonatomic, strong)NSString *headimg;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *addtime;
@property (nonatomic, strong)NSString *like_count;
@property (nonatomic, strong)NSString *reply_count;
@property (nonatomic, strong)NSString *reply_nickname;
@property (nonatomic, strong)NSString *is_liked;

@end
