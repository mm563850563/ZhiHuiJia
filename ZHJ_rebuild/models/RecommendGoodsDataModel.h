//
//  RecommendGoodsDataModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/3.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "HomeGoodsListModel.h"

@protocol HomeGoodsListModel <NSObject>
@end

@interface RecommendGoodsDataModel : JSONModel

@property (nonatomic, strong)NSArray<HomeGoodsListModel> *result;

@end
