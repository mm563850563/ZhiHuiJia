//
//  MyCircleDynamicResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MyCircleDynamicTips_infoModel.h"
#import "MyCircleDynamicReply_infoModel.h"

@protocol MyCircleDynamicTips_infoModel <NSObject>
@end

@protocol MyCircleDynamicReply_infoModel <NSObject>
@end

@interface MyCircleDynamicResultModel : JSONModel

@property (nonatomic, strong)NSString *talk_id;
@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *headimg;
@property (nonatomic, strong)NSString *topic_id;
@property (nonatomic, strong)NSString *topic_title;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *addtime;
@property (nonatomic, strong)NSString *like_count;
@property (nonatomic, strong)NSString *reply_count;
@property (nonatomic, strong)NSArray *images;
@property (nonatomic, strong)NSArray<MyCircleDynamicTips_infoModel> *tips_info;
@property (nonatomic, strong)NSString *is_liked;


@property (nonatomic, strong)NSString<Optional> *is_attentioned;
@property (nonatomic, strong)NSArray<MyCircleDynamicReply_infoModel,Optional> *reply_info;






@end
