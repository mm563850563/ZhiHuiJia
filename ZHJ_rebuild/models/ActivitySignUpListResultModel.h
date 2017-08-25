//
//  ActivitySignUpListResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ActivitySignUpListResultModel : JSONModel

@property (nonatomic, strong)NSString *friend_user_id;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSString *reason;
@property (nonatomic, strong)NSString *is_attentioned;

@end
