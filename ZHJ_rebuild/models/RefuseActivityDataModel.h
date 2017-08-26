//
//  RefuseActivityDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "RefuseActivityResultModel.h"

@protocol RefuseActivityResultModel <NSObject>
@end

@interface RefuseActivityDataModel : JSONModel

@property (nonatomic, strong)NSArray<RefuseActivityResultModel> *result;

@end
