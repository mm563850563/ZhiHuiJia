//
//  BrandDetailResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "BrandDetail_BrandDetailModel.h"
#import "BrandDetail_BrandGoodsModel.h"

@protocol BrandDetail_BrandGoodsModel <NSObject>
@end

@interface BrandDetailResultModel : JSONModel

@property (nonatomic, strong)BrandDetail_BrandDetailModel *brand_detail;
@property (nonatomic, strong)NSArray<BrandDetail_BrandGoodsModel> *brand_goods;

@end
