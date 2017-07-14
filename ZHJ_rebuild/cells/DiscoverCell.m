//
//  DiscoverCell.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/12.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DiscoverCell.h"

//views
#import "SegmentTapView.h"
#import "FlipTableView.h"

//controllers
#import "DiscoverDynamicViewController.h"
#import "DiscoverHotTopicViewController.h"
#import "DiscoverRecommendViewController.h"

@interface DiscoverCell ()<SegmentTapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *segmentBGView;
@property (weak, nonatomic) IBOutlet UIView *flipBGView;

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipView;

@end

@implementation DiscoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)drawRect:(CGRect)rect
{
    NSLog(@"%f",self.segmentBGView.frame.size.width);
    //segmentView
    NSArray *titleArray = @[@"精选动态",@"热门话题",@"活动推荐"];
    self.segmentView = [[SegmentTapView alloc]initWithFrame:self.segmentBGView.bounds withDataArray:titleArray withFont:14];
    self.segmentView.delegate = self;
    [self.segmentBGView addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //flipView
    DiscoverDynamicViewController *vc1 = [[DiscoverDynamicViewController alloc]init];
    DiscoverHotTopicViewController *vc2 = [[DiscoverHotTopicViewController alloc]init];
    DiscoverRecommendViewController *vc3 = [[DiscoverRecommendViewController alloc]init];
    
    NSMutableArray *vcArray = [NSMutableArray array];
    [vcArray addObject:vc1];
    [vcArray addObject:vc2];
    [vcArray addObject:vc3];
    
    self.flipView = [[FlipTableView alloc]initWithFrame:self.flipBGView.bounds withArray:vcArray];
    self.flipView.scrollEnabled = NO;
    [self.flipBGView addSubview:self.flipView];
}








#pragma mark - ****** SegmentTapViewDelegate *******
-(void)selectedIndex:(NSInteger)index
{
    [self.flipView selectIndex:index];
}


@end
