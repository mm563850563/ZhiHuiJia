//
//  OrderConfirmGoodsInfoModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/9.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OrderConfirmGoodsInfoModel : JSONModel

@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *goods_num;
@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)NSString *spec_key;
@property (nonatomic, strong)NSString *spec_name;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSString *goods_id;

@end
