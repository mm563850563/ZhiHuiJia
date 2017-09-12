//
//  GoodsDetailResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/2.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GoodsDetailImageModel.h"
#import "GoodsDetailContentModel.h"
#import "GoodsDetailGoodsInfoModel.h"
#import "GoodsDetailSpec_ListModel.h"

@protocol GoodsDetailImageModel <NSObject>
@end

@protocol GoodsDetailContentModel <NSObject>
@end

@protocol GoodsDetailSpec_ListModel <NSObject>
@end

@interface GoodsDetailResultModel : JSONModel

@property (nonatomic, strong)NSString<Optional> *is_collected;
@property (nonatomic, strong)GoodsDetailGoodsInfoModel<Optional> *goods_info;
@property (nonatomic, strong)NSArray<GoodsDetailContentModel,Optional> *goods_content;
@property (nonatomic, strong)NSArray<GoodsDetailImageModel,Optional> *goods_images;
@property (nonatomic, strong)NSArray<GoodsDetailSpec_ListModel,Optional> *spec_list;

@end
