//
//  HomeGoodsResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "HomeGoodsBigImageModel.h"
#import "HomeGoodsListModel.h"

@protocol HomeGoodsListModel <NSObject>
@end

@interface HomeGoodsResultModel : JSONModel

@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)HomeGoodsBigImageModel *big_img;
@property (nonatomic, strong)NSArray<HomeGoodsListModel> *goods_list;

@end
