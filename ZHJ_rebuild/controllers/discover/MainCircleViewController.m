//
//  MainCircleViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MainCircleViewController.h"

//views
#import "SegmentTapView.h"
#import "FlipTableView.h"

//controllers
#import "HotCircleViewController.h"
#import "MyCircleViewController.h"
#import "RankingListViewController.h"

@interface MainCircleViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *segmentBGView;
@property (weak, nonatomic) IBOutlet UIView *flipBGView;

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipView;

@end

@implementation MainCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingSelf];
    [self initSegmentView];
    [self initFlipView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)settingSelf
{
    self.view.backgroundColor = kColorFromRGB(kLightGray);
}

#pragma mark - <初始化segmentView>
-(void)initSegmentView
{
    NSArray *array = @[@"热门圈子",@"我的圈子",@"排行榜"];
    self.segmentView = [[SegmentTapView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40) withDataArray:array withFont:14];
    self.segmentView.delegate = self;
    [self.segmentBGView addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

#pragma mark - <初始化flipView>
-(void)initFlipView
{
    HotCircleViewController *hotCircleVC = [[HotCircleViewController alloc]initWithNibName:NSStringFromClass([HotCircleViewController class]) bundle:nil];
    MyCircleViewController *myCircleVC = [[MyCircleViewController alloc]initWithNibName:NSStringFromClass([MyCircleViewController class]) bundle:nil];
    RankingListViewController *rankListVC = [[RankingListViewController alloc]initWithNibName:NSStringFromClass([RankingListViewController class]) bundle:nil];
    NSMutableArray *vcArray = [NSMutableArray array];
    [vcArray addObject:hotCircleVC];
    [vcArray addObject:myCircleVC];
    [vcArray addObject:rankListVC];
    
    self.flipView = [[FlipTableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.flipBGView.frame.size.height) withArray:vcArray];
    self.flipView.delegate = self;
    [self.flipBGView addSubview:self.flipView];
    [self.flipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}




#pragma mark - **** SegmentTapViewDelegate,FlipTableViewDelegate ****
-(void)selectedIndex:(NSInteger)index
{
    [self.flipView selectIndex:index];
}

-(void)scrollChangeToIndex:(NSInteger)index
{
    [self.segmentView selectIndex:index];
}



@end
