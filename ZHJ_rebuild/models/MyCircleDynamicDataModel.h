//
//  MyCircleDynamicDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MyCircleDynamicResultModel.h"

@protocol MyCircleDynamicResultModel <NSObject>
@end

@interface MyCircleDynamicDataModel : JSONModel

@property (nonatomic, strong)NSArray<MyCircleDynamicResultModel> *result;

@end
