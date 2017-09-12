//
//  ShakeDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ShakeResultModel.h"

@interface ShakeDataModel : JSONModel

@property (nonatomic, strong)ShakeResultModel *result;

@end
