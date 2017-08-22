//
//  MyTrackGoodsInfoModel.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MyTrackGoodsInfoModel : JSONModel

@property (nonatomic, strong)NSString *goods_id;
@property (nonatomic, strong)NSString *addtime;
@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSString *goods_price;

@end
