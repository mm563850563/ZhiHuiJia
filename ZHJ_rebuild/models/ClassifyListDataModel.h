//
//  ClassifyListDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/1.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ClassifyListResultModel.h"

@protocol ClassifyListResultModel <NSObject>
@end

@interface ClassifyListDataModel : JSONModel

@property (nonatomic, strong)NSArray<ClassifyListResultModel> *result;

@end
