//
//  HomeGoodsDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "HomeGoodsResultModel.h"

@protocol HomeGoodsResultModel <NSObject>

@end

@interface HomeGoodsDataModel : JSONModel

@property (nonatomic, strong)NSArray<HomeGoodsResultModel> *result;

@end
