//
//  FriendHomePageResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/30.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FriendHomePageUser_infoModel.h"

@interface FriendHomePageResultModel : JSONModel

@property (nonatomic, strong)FriendHomePageUser_infoModel *user_info;
@property (nonatomic, strong)NSString *is_attentioned;
@property (nonatomic, strong)NSString *attentions;
@property (nonatomic, strong)NSString *fans;

@end
