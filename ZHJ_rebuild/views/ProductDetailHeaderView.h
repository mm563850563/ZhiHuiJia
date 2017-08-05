//
//  ProductDetailHeaderView.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/3.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailGoodsInfoModel.h"

@interface ProductDetailHeaderView : UIView

@property (nonatomic, strong)GoodsDetailGoodsInfoModel *modelInfo;
@property (nonatomic, strong)NSArray *bannerArray;
@property (nonatomic, strong)NSArray *spec_listArray;

@end
