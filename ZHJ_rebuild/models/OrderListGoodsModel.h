//
//  OrderListGoodsModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/16.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OrderListGoodsModel : JSONModel

@property (nonatomic, strong)NSString *goods_id;
@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSString *goods_num;
@property (nonatomic, strong)NSString *goods_price;
@property (nonatomic, strong)NSString *market_price;
@property (nonatomic, strong)NSString *spec_key_name;

@end
