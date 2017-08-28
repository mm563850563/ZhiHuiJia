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
#import "ApplyCircleViewController.h"
#import "MoreCycleViewController.h"
#import "CircleDetailViewController.h"

@interface MainCircleViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>

//@property (weak, nonatomic) IBOutlet UIView *segmentBGView;
//@property (weak, nonatomic) IBOutlet UIView *flipBGView;

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipView;

@property (nonatomic, strong)UIView *applyCircleView;

@end

@implementation MainCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingSelf];
    [self initSegmentView];
    [self initFlipView];
    [self initApplyCircle];
    
    [self respondWithRAC];
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

#pragma mark - <初始化“申请圈子”按钮>
-(void)initApplyCircle
{
    self.applyCircleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.view addSubview:self.applyCircleView];
    [self.applyCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-40);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    self.applyCircleView.backgroundColor = kColorFromRGB(kThemeYellow);
    self.applyCircleView.layer.cornerRadius = 30;
    self.applyCircleView.layer.masksToBounds = YES;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.applyCircleView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.size.mas_offset(CGSizeMake(30, 30));
        make.centerX.mas_equalTo(0);
    }];
    imgView.image = [UIImage imageNamed:@"pen"];
    imgView.layer.cornerRadius = 15;
    imgView.layer.masksToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.applyCircleView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(imgView.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    label.text = @"申请圈子";
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = kColorFromRGB(kDeepGray);
    label.textAlignment = NSTextAlignmentCenter;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.applyCircleView.bounds;
    [self.applyCircleView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [button addTarget:self action:@selector(jumpToApplyCircleVC) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - <跳转“申请圈子”页面>
-(void)jumpToApplyCircleVC
{
    ApplyCircleViewController *applyCircleVC = [[ApplyCircleViewController alloc]initWithNibName:NSStringFromClass([ApplyCircleViewController class]) bundle:nil];
    applyCircleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:applyCircleVC animated:YES];
}

#pragma mark - <初始化segmentView>
-(void)initSegmentView
{
    NSArray *array = @[@"热门圈子",@"我的圈子",@"排行榜"];
    self.segmentView = [[SegmentTapView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40) withDataArray:array withFont:14];
    self.segmentView.delegate = self;
    [self.view addSubview:self.segmentView];
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
    
    self.flipView = [[FlipTableView alloc]initWithFrame:CGRectMake(0, 41, kSCREEN_WIDTH, self.view.frame.size.height-41-64) withArray:vcArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}

#pragma mark - <跳转更多圈子页面>
-(void)jumpToMoreCircleVCWithMoreType:(NSString *)moreType classifyID:(NSString *)classify_id
{
    MoreCycleViewController *moreCircleVC = [[MoreCycleViewController alloc]initWithNibName:NSStringFromClass([MoreCycleViewController class]) bundle:nil];
    moreCircleVC.moreType = moreType;
    moreCircleVC.classify_id = classify_id;
    moreCircleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreCircleVC animated:YES];
}

#pragma mark - <跳转“圈子详情”页面>
-(void)jumpToCircleDetailVCWithCircleID:(NSString *)circle_id
{
    CircleDetailViewController *circleDetailVC = [[CircleDetailViewController alloc]initWithNibName:NSStringFromClass([CircleDetailViewController class]) bundle:nil];
    circleDetailVC.circle_id = circle_id;
    circleDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:circleDetailVC animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    //更多我加入的圈子
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToMoreCircleFromMyCircle" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *moreType = x.object;
        [self jumpToMoreCircleVCWithMoreType:moreType classifyID:nil];
    }];
    
    //更多热门圈子
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToMoreHotCircle" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSDictionary *dict = x.object;
        [self jumpToMoreCircleVCWithMoreType:dict[@"moreType"] classifyID:dict[@"classify_id"]];
    }];
    
    //圈子详情
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToCircleDetailVC" object:nil] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *circle_id = x.object;
        [self jumpToCircleDetailVCWithCircleID:circle_id];
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
