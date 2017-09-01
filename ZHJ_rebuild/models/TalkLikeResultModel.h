//
//  TalkLikeResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/1.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TalkLikeResultModel : JSONModel

@property (nonatomic, strong)NSString *like_id;
@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *headimg;
@property (nonatomic, strong)NSString *sex;
@property (nonatomic, strong)NSString *age;
@property (nonatomic, strong)NSString *is_attentioned;

@end
