//
//  CircleDetailResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/28.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CircleDetailSignin_membersModel.h"

@protocol CircleDetailSignin_membersModel <NSObject>
@end

@interface CircleDetailResultModel : JSONModel

@property (nonatomic, strong)NSString *circle_id;
@property (nonatomic, strong)NSString *circle_name;
@property (nonatomic, strong)NSString *members_count;
@property (nonatomic, strong)NSString *img;
@property (nonatomic, strong)NSString *news;
@property (nonatomic, strong)NSString *is_signin;
@property (nonatomic, strong)NSString *is_attentioned;
@property (nonatomic, strong)NSString *signin_count;
@property (nonatomic, strong)NSArray<CircleDetailSignin_membersModel> *signin_members;

@end
