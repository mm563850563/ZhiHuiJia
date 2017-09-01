//
//  GoodsDetailGoodsInfoModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/2.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GoodsDetailGoodsInfoModel : JSONModel

@property (nonatomic, strong)NSString *goods_id;
@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *goods_remark;
@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)NSString *market_price;
@property (nonatomic, strong)NSString *comment_count;
@property (nonatomic, strong)NSString *average_score;
@property (nonatomic, strong)NSString *brand_id;
@property (nonatomic, strong)NSString *goods_number;

@end
