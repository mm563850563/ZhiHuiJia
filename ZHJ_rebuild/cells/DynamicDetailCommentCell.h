//
//  DynamicDetailCommentCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DynamicDetailCommentResultModel;

@interface DynamicDetailCommentCell : UITableViewCell

@property (nonatomic, strong)DynamicDetailCommentResultModel *modelDynamicCommentResult;
@property (nonatomic, assign)CGFloat cellHeight;

@property (nonatomic, strong)NSString *whereReuseFrom;

@end