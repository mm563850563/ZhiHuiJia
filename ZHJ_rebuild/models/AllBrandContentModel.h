//
//  AllBrandContentModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AllBrandListModel.h"
#import "AllBrandGoodsListModel.h"

@protocol AllBrandListModel <NSObject>
@end

@protocol AllBrandGoodsListModel <NSObject>
@end

@interface AllBrandContentModel : JSONModel

@property (nonatomic, strong)NSString *banner;
@property (nonatomic, strong)NSString *goods_id;
@property (nonatomic, strong)NSArray<AllBrandListModel> *brand_list;
@property (nonatomic, strong)NSArray<AllBrandGoodsListModel> *goods_list;

@end
