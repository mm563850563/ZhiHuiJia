//
//  WaitToReviewActivityCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaitToReviewActivityResultModel;

@interface WaitToReviewActivityCell : UITableViewCell

@property (nonatomic, strong)WaitToReviewActivityResultModel *modelWaitToReviewResult;

@property (nonatomic, strong)NSString *reviewStatus;

@end
