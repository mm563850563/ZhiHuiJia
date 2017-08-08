//
//  UserFavoriteDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/5.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "UserFavoriteResultModel.h"

@protocol UserFavoriteResultModel <NSObject>
@end

@interface UserFavoriteDataModel : JSONModel

@property (nonatomic, strong)NSArray<UserFavoriteResultModel> *result;

@end
