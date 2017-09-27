//
//  SearchCircleDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "SearchCircleResultModel.h"

@protocol SearchCircleResultModel <NSObject>
@end

@interface SearchCircleDataModel : JSONModel

@property (nonatomic, strong)NSArray<SearchCircleResultModel> *result;

@end
