//
//  DynamicDetailDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MyCircleDynamicResultModel.h"

@interface DynamicDetailDataModel : JSONModel

@property (nonatomic, strong)MyCircleDynamicResultModel *result;

@end
