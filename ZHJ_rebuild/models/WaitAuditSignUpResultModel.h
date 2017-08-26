//
//  WaitAuditSignUpResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface WaitAuditSignUpResultModel : JSONModel

@property (nonatomic, strong)NSString<Optional> *signup_id;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *headimg;
@property (nonatomic, strong)NSString *reason;

@property (nonatomic, strong)NSString<Optional> *friend_user_id;
@property (nonatomic, strong)NSString<Optional> *is_attentioned;

@end
