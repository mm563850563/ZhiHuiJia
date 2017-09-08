//
//  RecommendGoodsCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecommendGoodsDataModel;

@interface RecommendGoodsCell : UITableViewCell

@property (nonatomic, strong)RecommendGoodsDataModel *modelRecommendData;
@property (nonatomic,assign)CGFloat cellHeight;

@end
