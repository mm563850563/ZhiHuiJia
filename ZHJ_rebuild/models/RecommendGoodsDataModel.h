//
//  RecommendGoodsDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/3.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "RecommendGoodsResultModel.h"

@protocol RecommendGoodsResultModel <NSObject>
@end

@interface RecommendGoodsDataModel : JSONModel

@property (nonatomic, strong)NSArray<RecommendGoodsResultModel> *result;

@end
