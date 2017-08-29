//
//  SigninListResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SigninListResultModel : JSONModel

@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *headimg;
@property (nonatomic, strong)NSString *sex;
@property (nonatomic, strong)NSString *age;
@property (nonatomic, strong)NSString *addtime;

@end
