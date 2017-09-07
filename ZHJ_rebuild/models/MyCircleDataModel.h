//
//  MyCircleDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MyCircleResultModel.h"

@interface MyCircleDataModel : JSONModel

@property (nonatomic, strong)MyCircleResultModel *result;

@end
