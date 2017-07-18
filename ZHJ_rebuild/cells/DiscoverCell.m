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

@interface DiscoverCell ()<FlipTableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *flipBGView;

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipView;

@end

@implementation DiscoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self respondWithRAC];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)drawRect:(CGRect)rect
{
    //flipView
    DiscoverDynamicViewController *vc1 = [[DiscoverDynamicViewController alloc]init];
    DiscoverHotTopicViewController *vc2 = [[DiscoverHotTopicViewController alloc]init];
    DiscoverRecommendViewController *vc3 = [[DiscoverRecommendViewController alloc]init];
    
    NSMutableArray *vcArray = [NSMutableArray array];
    [vcArray addObject:vc1];
    [vcArray addObject:vc2];
    [vcArray addObject:vc3];
    
    self.flipView = [[FlipTableView alloc]initWithFrame:self.flipBGView.bounds withArray:vcArray];
    self.flipView.scrollEnabled = YES;
    self.flipView.delegate = self;
    [self.flipBGView addSubview:self.flipView];
    [self.flipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"Discover_Segment" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSNumber *num = x.object;
        NSInteger index = [num integerValue];
        [self.flipView selectIndex:index];
    }];
}

-(void)scrollChangeToIndex:(NSInteger)index
{
    NSNumber *indexNum = [NSNumber numberWithInteger:index];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Discover_Filp" object:indexNum];
}







@end
