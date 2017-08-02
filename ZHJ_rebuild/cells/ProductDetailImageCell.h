//
//  ProductDetailImageCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsDetailContentModel;

@interface ProductDetailImageCell : UITableViewCell

@property (nonatomic, strong)GoodsDetailContentModel *model;
@property (nonatomic, assign)CGFloat cellHeight;

@end
