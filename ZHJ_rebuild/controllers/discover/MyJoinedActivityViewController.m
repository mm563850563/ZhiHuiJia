//
//  MyJoinedActivityViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyJoinedActivityViewController.h"

//views
#import "SegmentTapView.h"
#import "FlipTableView.h"

//controllers
#import "MyJoinedActivityListViewController.h"
#import "ActivityRecommendDetailViewController.h"

@interface MyJoinedActivityViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipView;

@end

@implementation MyJoinedActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSegmentView];
    [self initFlipView];
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




#pragma mark - <初始化segmentView>
-(void)initSegmentView
{
    NSArray *array = @[@"等待审核",@"已通过",@"审核失败"];
    self.segmentView = [[SegmentTapView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40) withDataArray:array withFont:14];
    self.segmentView.delegate = self;
    [self.view addSubview:self.segmentView];
    //    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    //    }];
    
}

#pragma mark - <初始化flipView>
-(void)initFlipView
{
    MyJoinedActivityListViewController *waitReviewVC = [[MyJoinedActivityListViewController alloc]initWithNibName:NSStringFromClass([MyJoinedActivityListViewController class]) bundle:nil];
    waitReviewVC.status = @"0";
    
    MyJoinedActivityListViewController *passedVC = [[MyJoinedActivityListViewController alloc]initWithNibName:NSStringFromClass([MyJoinedActivityListViewController class]) bundle:nil];
    passedVC.status = @"1";
    
    MyJoinedActivityListViewController *failureReviewVC = [[MyJoinedActivityListViewController alloc]initWithNibName:NSStringFromClass([MyJoinedActivityListViewController class]) bundle:nil];
    failureReviewVC.status = @"2";
    
    NSMutableArray *vcArray = [NSMutableArray array];
    [vcArray addObject:waitReviewVC];
    [vcArray addObject:passedVC];
    [vcArray addObject:failureReviewVC];
    
    self.flipView = [[FlipTableView alloc]initWithFrame:CGRectMake(0, 40, kSCREEN_WIDTH, self.view.frame.size.height-40-64) withArray:vcArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
    //    [self.flipView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    //    }];
}

#pragma mark - <跳转activityRecommendDetailVC>
-(void)jumpToActivityRecommendDetailVCWithActivityID:(NSString *)activity_id
{
    ActivityRecommendDetailViewController *activityRecommendDetailVC = [[ActivityRecommendDetailViewController alloc]initWithNibName:NSStringFromClass([ActivityRecommendDetailViewController class]) bundle:nil];
    activityRecommendDetailVC.activity_id = activity_id;
    activityRecommendDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityRecommendDetailVC animated:YES];
}


#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //跳转活动详情
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToActivityDetailVCFromMyJoined" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *activity_id = x.object;
        [self jumpToActivityRecommendDetailVCWithActivityID:activity_id];
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
