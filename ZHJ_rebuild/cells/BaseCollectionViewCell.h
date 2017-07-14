//
//  BaseCollectionViewCell.h
//  ZhiHuiJia
//
//  Created by sophia on 17/7/6.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseModel;

@interface BaseCollectionViewCell : UICollectionViewCell

-(void)setDataWithModel:(BaseModel *)model;

@end
