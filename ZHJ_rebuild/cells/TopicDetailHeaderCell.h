//
//  TopicDetailHeaderCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/2.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopicDetailResultModel;

@interface TopicDetailHeaderCell : UITableViewCell

@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, strong)TopicDetailResultModel *modelResult;

@end
