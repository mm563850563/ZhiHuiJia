//
//  CircleDetailDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/28.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CircleDetailResultModel.h"

@interface CircleDetailDataModel : JSONModel

@property (nonatomic, strong)CircleDetailResultModel *result;

@end
