//
//  BrandAppliedCollectionCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AllBrandListModel;

@interface BrandAppliedCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgBrand;
@property (nonatomic, strong)AllBrandListModel *model;

@end
