//
//  AfterSaleListResultModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AfterSaleListResultModel : JSONModel

@property (nonatomic, strong)NSString *return_goods_id;
@property (nonatomic, strong)NSString *order_sn;
@property (nonatomic, strong)NSString *addtime;
@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSString *spec_key_name;
@property (nonatomic, strong)NSString *goods_num;
@property (nonatomic, strong)NSString *status;
@property (nonatomic, strong)NSString *goods_price;

@end
