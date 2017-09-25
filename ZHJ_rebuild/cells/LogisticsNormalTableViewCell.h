//
//  LogisticsNormalTableViewCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LogisticsRealTimeModel;

@interface LogisticsNormalTableViewCell : UITableViewCell

@property (nonatomic, strong)LogisticsRealTimeModel *modelRealTime;
@property (nonatomic, assign)CGFloat cellHeight;

@end
