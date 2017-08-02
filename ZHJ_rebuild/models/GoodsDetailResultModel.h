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

@protocol GoodsDetailImageModel <NSObject>
@end

@protocol GoodsDetailContentModel <NSObject>
@end

@interface GoodsDetailResultModel : JSONModel

@property (nonatomic, strong)GoodsDetailGoodsInfoModel *goods_info;
@property (nonatomic, strong)NSArray<GoodsDetailContentModel> *goods_content;
@property (nonatomic, strong)NSArray<GoodsDetailImageModel> *goods_images;

@end
