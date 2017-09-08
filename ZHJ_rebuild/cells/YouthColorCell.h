//
//  YouthColorCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeGoodsResultModel;

@interface YouthColorCell : UITableViewCell

@property (nonatomic, strong)HomeGoodsResultModel *model;
//@property (nonatomic, strong)NSArray *recommendGoodsArray;
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic, strong)NSArray *userFavoriteArray;

@property (nonatomic, strong)NSString *fromWhere;

@end
