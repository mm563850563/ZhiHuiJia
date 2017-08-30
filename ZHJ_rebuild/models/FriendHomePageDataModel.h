//
//  FriendHomePageDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/30.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FriendHomePageResultModel.h"

@interface FriendHomePageDataModel : JSONModel

@property (nonatomic, strong)FriendHomePageResultModel *result;

@end
