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

@interface MainCircleViewController ()<SegmentTapViewDelegate>

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
#warning *********** 暂时隐藏该功能 **********
//    [self initApplyCircle];
    
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
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.applyCircleView.bounds];
    [self.applyCircleView addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"apply_circle"];
    imgView.layer.cornerRadius = 30;
    imgView.layer.masksToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
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
    
    NSMutableArray *vcArray = [NSMutableArray array];
    [vcArray addObject:hotCircleVC];
    
    self.flipView = [[FlipTableView alloc]initWithFrame:CGRectMake(0, 41, kSCREEN_WIDTH, self.view.frame.size.height-41-64) withArray:vcArray];
    [self.view addSubview:self.flipView];
}

#pragma mark - <跳转“我的圈子”页面>
-(void)jumpToMyCircleVC
{
    MyCircleViewController *myCircleVC = [[MyCircleViewController alloc]initWithNibName:NSStringFromClass([MyCircleViewController class]) bundle:nil];
    myCircleVC.navigationItem.title = @"我的圈子";
    [self.navigationController pushViewController:myCircleVC animated:YES];
}

#pragma mark - <跳转“排行榜”页面>
-(void)jumpToRankListVC
{
    RankingListViewController *rankListVC = [[RankingListViewController alloc]initWithNibName:NSStringFromClass([RankingListViewController class]) bundle:nil];
    rankListVC.navigationItem.title = @"活跃排行榜";
    [self.navigationController pushViewController:rankListVC animated:YES];
}

#pragma mark - <跳转“圈子详情”页面>
-(void)jumpToCircleDetailVCWithCircleID:(NSString *)circle_id
{
    CircleDetailViewController *circleDetailVC = [[CircleDetailViewController alloc]initWithNibName:NSStringFromClass([CircleDetailViewController class]) bundle:nil];
    circleDetailVC.circle_id = circle_id;
    circleDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:circleDetailVC animated:YES];
}

#pragma mark - <跳转更多圈子页面>
-(void)jumpToMoreCircleVCWithMoreType:(NSString *)moreType classifyID:(NSString *)classify_id navigationItemTitle:(NSString *)title
{
    MoreCycleViewController *moreCircleVC = [[MoreCycleViewController alloc]initWithNibName:NSStringFromClass([MoreCycleViewController class]) bundle:nil];
    moreCircleVC.moreType = moreType;
    moreCircleVC.classify_id = classify_id;
    moreCircleVC.hidesBottomBarWhenPushed = YES;
    moreCircleVC.navigationItem.title = title;
    [self.navigationController pushViewController:moreCircleVC animated:YES];
}


#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    //更多热门圈子
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToMoreHotCircle" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSDictionary *dict = x.object;
        [self jumpToMoreCircleVCWithMoreType:dict[@"moreType"] classifyID:dict[@"classify_id"] navigationItemTitle:dict[@"classify_name"]];
    }];
    
    //圈子详情
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToCircleDetailVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *circle_id = x.object;
        [self jumpToCircleDetailVCWithCircleID:circle_id];
    }];
}









#pragma mark - **** SegmentTapViewDelegate,FlipTableViewDelegate ****
-(void)selectedIndex:(NSInteger)index
{
    [self.segmentView selectIndex:1];
    
    if (index == 1) {
        [self jumpToMyCircleVC];
    }else if (index == 2){
        [self jumpToRankListVC];
    }
}



@end
