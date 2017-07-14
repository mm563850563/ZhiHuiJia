//
//  FactoryCollectionViewCell.h
//  ZhiHuiJia
//
//  Created by sophia on 17/7/6.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class BaseCollectionViewCell;
@class BaseModel;

@interface FactoryCollectionViewCell : NSObject

#pragma mark - <创建cell的工厂类>
+(BaseCollectionViewCell *)createTableViewCellWithModel:(BaseModel *)model collection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
