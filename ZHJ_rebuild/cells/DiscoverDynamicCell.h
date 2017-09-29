//
//  DiscoverDynamicCell.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/18.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCircleDynamicResultModel.h"

@protocol DiscoverDynamicCellDelegate <NSObject>

-(void)didClickBtnFocus:(UIButton *)btnFocus index:(NSInteger)index user_id:(NSString *)user_id;
-(void)didClickBtnLike:(UIButton *)btnLike index:(NSInteger)index talk_id:(NSString *)talk_id;

@end

@interface DiscoverDynamicCell : UITableViewCell

@property (nonatomic, weak)id<DiscoverDynamicCellDelegate> delegate;

@property (nonatomic, strong)MyCircleDynamicResultModel *modelCircleDynamicResult;
@property (nonatomic, assign)CGFloat cellHeight;

@property (nonatomic, strong)UIButton *btnOnFocus;
@property (nonatomic, strong)UIButton *btnLike;


//区别：从哪个页面复用cell
@property (nonatomic, strong)NSString *whereReuseFrom;


@end
