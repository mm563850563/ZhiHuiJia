//
//  BrandDetail_BrandGoodsModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BrandDetail_BrandGoodsModel : JSONModel

@property (nonatomic, strong)NSString *goods_id;
@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSString *goods_remark;
@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)NSString *market_price;
@property (nonatomic, strong)NSString *average_score;
@property (nonatomic, strong)NSString *comment_count;

@end
