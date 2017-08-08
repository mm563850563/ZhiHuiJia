//
//  HomeCollectCell1.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeGoodsListModel;
@class UserFavoriteResultModel;

@interface HomeCollectCell1 : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductDetail;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelCompare;

@property (nonatomic, strong)HomeGoodsListModel *model;
@property (nonatomic, strong)UserFavoriteResultModel *modelUserFavorite;

@end
