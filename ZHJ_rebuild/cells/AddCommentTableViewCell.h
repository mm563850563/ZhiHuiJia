//
//  AddCommentTableViewCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/23.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderListGoodsModel.h"
#import "OrderList_OrderListModel.h"

@class RatingBar;
@class SSCheckBoxView;

@interface AddCommentTableViewCell : UITableViewCell

@property (nonatomic, strong)OrderListGoodsModel *modelGoods;
@property (nonatomic, strong)OrderList_OrderListModel *modelOrderList;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UIView *starBGView;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UITextView *tvCommentContent;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UIView *checkBoxBGView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong)RatingBar *starBar;
@property (nonatomic, strong)SSCheckBoxView *checkBox;
@property (nonatomic, strong)NSString *is_anonymous; //是否匿名
@property (nonatomic, assign)NSInteger goods_grade;
@property (nonatomic, strong)NSString *spec_key;

@end
