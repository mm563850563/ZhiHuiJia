//
//  SameHobbyPersonListCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetSimilarUserResultModel;

@protocol SameHobbyPersonListCellDelegate <NSObject>

-(void)didClickBtnFocus:(UIButton *)btnFocus user_id:(NSString *)user_id;

@end

@interface SameHobbyPersonListCell : UITableViewCell

@property (nonatomic, strong)GetSimilarUserResultModel *modelResult;
@property (nonatomic, strong)NSString *whereReuseFrom;
@property (nonatomic, weak)id<SameHobbyPersonListCellDelegate> delegate;

@end
