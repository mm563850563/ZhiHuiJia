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

@interface AddCommentTableViewCell : UITableViewCell

@property (nonatomic, strong)OrderListGoodsModel *modelGoods;
@property (nonatomic, strong)OrderList_OrderListModel *modelOrderList;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
