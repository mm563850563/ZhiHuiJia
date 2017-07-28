//
//  Categate_CategateCollectCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AllClassifyChildrenSecondModel;

@interface Categate_CategateCollectCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (nonatomic, strong)AllClassifyChildrenSecondModel *model;

@end
