//
//  CommentListCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/24.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductCommentResultModel;

@interface CommentListCell : UITableViewCell

@property (nonatomic, strong)ProductCommentResultModel *modelProductCommentResult;
@property (nonatomic, assign)CGFloat cellHeight;

//记录该cell被谁复用
@property (nonatomic, strong)NSString *whereReuseFrom;

@end
