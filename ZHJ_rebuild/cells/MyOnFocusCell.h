//
//  MyOnFocusCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TalkLikeResultModel;
@class MyFansAndMyFocusResultModel;

@interface MyOnFocusCell : UITableViewCell

@property (nonatomic, strong)TalkLikeResultModel *modelTalkLikeResult;
@property (nonatomic, strong)MyFansAndMyFocusResultModel *modelFansOrFocusResult;

@end
