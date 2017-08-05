//
//  CartList_CartListModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/5.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CartList_CartListModel : JSONModel

@property (nonatomic, strong)NSString *cart_id;
@property (nonatomic, strong)NSString *goods_id;
@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *market_price;
@property (nonatomic, strong)NSString *goods_price;
@property (nonatomic, strong)NSString *member_goods_price;
@property (nonatomic, strong)NSString *goods_num;
@property (nonatomic, strong)NSString *spec_key;
@property (nonatomic, strong)NSString *key_name;
@property (nonatomic, strong)NSString *selected;
@property (nonatomic, strong)NSString *goods_fee;
@property (nonatomic, strong)NSString *store_count;
@property (nonatomic, strong)NSString *image;

//"cart_id": "6",
//"goods_id": "13",
//"goods_name": "自平衡电动独轮车",
//"image": "/public/upload/goods/2017/07-31/548c8199133f24a746807ccb27d0dad4.png",
//"market_price": "1899.00",
//"goods_price": "1799.00",
//"member_goods_price": "1799.00",
//"goods_num": "8",
//"spec_key": "1",
//"key_name": "颜色:黑色",
//"selected": "1",
//"goods_fee": 14392,
//"store_count": "100"

@end
