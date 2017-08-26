//
//  ActivityViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ActivityViewController.h"

//views
#import "SegmentTapView.h"
#import "FlipTableView.h"

//controllers
#import "WaitForReviewViewController.h"
#import "AlreadyPassedViewController.h"
#import "FailureReviewViewController.h"

#import "MyActivitySignUpListViewController.h"

@interface ActivityViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipView;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    WaitForReviewViewController *waitReviewVC = [[WaitForReviewViewController alloc]initWithNibName:NSStringFromClass([WaitForReviewViewController class]) bundle:nil];
    AlreadyPassedViewController *passedVC = [[AlreadyPassedViewController alloc]initWithNibName:NSStringFromClass([AlreadyPassedViewController class]) bundle:nil];
    FailureReviewViewController *failureReviewVC = [[FailureReviewViewController alloc]initWithNibName:NSStringFromClass([FailureReviewViewController class]) bundle:nil];
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

#pragma mark - <跳转“报名列表”页面>
-(void)jumpToSignUpListVCWithActivityID:(NSString *)activity_id
{
    MyActivitySignUpListViewController *myActivitySignUpListVC = [[MyActivitySignUpListViewController alloc]init];
    myActivitySignUpListVC.activity_id = activity_id;
    [self.navigationController pushViewController:myActivitySignUpListVC animated:YES];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToSignUpListVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *activity_id = x.object;
        [self jumpToSignUpListVCWithActivityID:activity_id];
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
