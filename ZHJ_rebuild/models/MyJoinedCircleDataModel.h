//
//  MyJoinedCircleDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MyJoinedCircleResultModel.h"

@protocol MyJoinedCircleResultModel <NSObject>
@end

@interface MyJoinedCircleDataModel : JSONModel

@property (nonatomic, strong)NSArray<MyJoinedCircleResultModel> *result;

@end