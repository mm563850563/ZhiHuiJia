//
//  MoreProductListCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/17.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassifyListResultModel;
@class BrandDetail_BrandGoodsModel;

@interface MoreProductListCell : UICollectionViewCell

@property (nonatomic, strong)ClassifyListResultModel *modelClassifyList;
@property (nonatomic, strong)BrandDetail_BrandGoodsModel *modelBrandGoods;

@end
