//
//  BrandDetailCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BrandDetail_BrandDetailModel;

@interface BrandDetailCell : UITableViewCell

@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)BrandDetail_BrandDetailModel *modelBrandDetail;
@property (nonatomic, assign)CGFloat cellHeight;

@end
