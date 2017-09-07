//
//  ClassifyCollectionViewCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassifyResultModel;

@interface ClassifyCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)ClassifyResultModel *modelResult;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewSelected;

@end
