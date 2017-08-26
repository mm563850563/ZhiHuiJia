//
//  PassedActivityReviewMemberViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyActivitySignUpListViewController.h"

//views
#import "SegmentTapView.h"
#import "FlipTableView.h"

//controllers
#import "MyActivitySignUpListWaitToReviewViewController.h"
#import "MyActivitySignUpListPassedViewController.h"

@interface MyActivitySignUpListViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipView;

@end

@implementation MyActivitySignUpListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingNavigation];
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

#pragma mark - <配置navigationBar>
-(void)settingNavigation
{
    self.navigationController.title = @"报名列表";
}

#pragma mark - <初始化segmentView>
-(void)initSegmentView
{
    NSArray *array = @[@"等待审核",@"已通过"];
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
    MyActivitySignUpListWaitToReviewViewController *signUpListWaitReviewVC = [[MyActivitySignUpListWaitToReviewViewController alloc]initWithNibName:NSStringFromClass([MyActivitySignUpListWaitToReviewViewController class]) bundle:nil];
    signUpListWaitReviewVC.activity_id = self.activity_id;
    
    MyActivitySignUpListPassedViewController *signUpListPassedVC = [[MyActivitySignUpListPassedViewController alloc]initWithNibName:NSStringFromClass([MyActivitySignUpListPassedViewController class]) bundle:nil];
    signUpListPassedVC.activity_id = self.activity_id;
    
    NSMutableArray *vcArray = [NSMutableArray array];
    [vcArray addObject:signUpListWaitReviewVC];
    [vcArray addObject:signUpListPassedVC];
    
    self.flipView = [[FlipTableView alloc]initWithFrame:CGRectMake(0, 40, kSCREEN_WIDTH, self.view.frame.size.height-40-64) withArray:vcArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
    //    [self.flipView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    //    }];
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
