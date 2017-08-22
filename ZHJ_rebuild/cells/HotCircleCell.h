//
//  HotCircleCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetHotCycleCircleInfoModel.h"
#import "MyJoinedCircleResultModel.h"

@interface HotCircleCell : UITableViewCell

@property (nonatomic, strong)GetHotCycleCircleInfoModel *modelCircleInfo;
@property (nonatomic,strong)MyJoinedCircleResultModel *modelJoinedCircle;

@end
