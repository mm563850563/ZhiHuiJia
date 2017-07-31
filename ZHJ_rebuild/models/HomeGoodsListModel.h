//
//  HomeGoodsListModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HomeGoodsListModel : JSONModel

@property (nonatomic, strong)NSString *goods_id;
@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *goods_remark;
@property (nonatomic, strong)NSString *img;

@end
