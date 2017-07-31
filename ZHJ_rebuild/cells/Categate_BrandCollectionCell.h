//
//  Categate_BrandCollectionCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AllBrandGoodsListModel;

@interface Categate_BrandCollectionCell : UICollectionViewCell

@property (nonatomic, strong)AllBrandGoodsListModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductPrice;

@end
