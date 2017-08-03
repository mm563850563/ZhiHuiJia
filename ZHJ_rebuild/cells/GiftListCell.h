//
//  GiftListCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetGiftList_GiftListModel;

@interface GiftListCell : UICollectionViewCell

@property (nonatomic, strong)GetGiftList_GiftListModel *model;
@property (nonatomic, strong)NSString *winGiftID;

@end
