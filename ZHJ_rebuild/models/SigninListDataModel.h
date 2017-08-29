//
//  SigninListDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "SigninListResultModel.h"

@protocol SigninListResultModel <NSObject>
@end

@interface SigninListDataModel : JSONModel
@property (nonatomic, strong)NSArray<SigninListResultModel> *result;
@end
