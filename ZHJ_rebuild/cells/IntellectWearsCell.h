//
//  IntellectWearsCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeGoodsResultModel;

@interface IntellectWearsCell : UITableViewCell

@property (nonatomic, strong)HomeGoodsResultModel *model;
@property (nonatomic, assign)CGFloat cellHeight;

@end
