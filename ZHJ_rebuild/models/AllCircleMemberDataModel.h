//
//  AllCircleMemberDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AllCircleMemberResultModel.h"

@protocol AllCircleMemberResultModel <NSObject>
@end

@interface AllCircleMemberDataModel : JSONModel

@property (nonatomic, strong)NSArray<AllCircleMemberResultModel> *result;

@end
