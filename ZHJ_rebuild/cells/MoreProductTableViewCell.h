//
//  MoreProductTableViewCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/1.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassifyListResultModel;
@class BrandDetail_BrandGoodsModel;

@interface MoreProductTableViewCell : UITableViewCell

@property (nonatomic, strong)ClassifyListResultModel *modelClassifyList;

@property (nonatomic, strong)BrandDetail_BrandGoodsModel *modelBrandGoods;

@end
