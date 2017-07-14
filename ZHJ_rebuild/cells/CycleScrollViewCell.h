//
//  CycleScrollViewCell.h
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CycleScrollViewCell;
@class CycleScrollModel;

@protocol CycleScrollViewCellDelegate <NSObject>

- (void)cycleScrollViewCell:(CycleScrollViewCell *)cycleScrollViewCell didSelectItemAtIndex:(NSInteger)index;

@end

@interface CycleScrollViewCell : UITableViewCell

@property (nonatomic, weak)id<CycleScrollViewCellDelegate> delegate;
@property (nonatomic, strong)CycleScrollModel *model;

@end
