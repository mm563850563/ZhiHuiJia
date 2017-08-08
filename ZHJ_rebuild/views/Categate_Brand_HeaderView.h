//
//  Categate_Brand_HeaderView.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllBrandContentModel.h"

@interface Categate_Brand_HeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (nonatomic, strong)AllBrandContentModel *model;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end
