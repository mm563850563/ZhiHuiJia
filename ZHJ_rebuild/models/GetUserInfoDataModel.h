//
//  GetUserInfoDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetUserInfoResultModel.h"

@protocol GetUserInfoResultModel <NSObject>
@end

@interface GetUserInfoDataModel : JSONModel

@property (nonatomic, strong)NSArray<GetUserInfoResultModel> *result;

@end
