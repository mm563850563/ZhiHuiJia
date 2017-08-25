//
//  ActivitySignUpListDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ActivitySignUpListResultModel.h"

@protocol ActivitySignUpListResultModel <NSObject>
@end

@interface ActivitySignUpListDataModel : JSONModel

@property (nonatomic, strong)NSArray<ActivitySignUpListResultModel> *result;

@end
