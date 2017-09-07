//
//  ClassifyDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ClassifyResultModel.h"

@protocol ClassifyResultModel <NSObject>
@end

@interface ClassifyDataModel : JSONModel

@property (nonatomic, strong)NSArray<ClassifyResultModel> *result;

@end
