//
//  LeftSideSegmentView.h
//  ZhiHuiJia
//
//  Created by sophia on 17/7/6.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LeftSideSegmentView;


@protocol LeftSideSegmentViewDelegate <NSObject>

-(void)leftSideSegmentView:(LeftSideSegmentView *)leftSideSegmentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface LeftSideSegmentView : UIView

@property (nonatomic,weak)id<LeftSideSegmentViewDelegate> delegate;

@property (nonatomic, strong)UITableView *LeftTableView;
@property (nonatomic, strong)UIView *rightContentView;


-(instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray;

@end
