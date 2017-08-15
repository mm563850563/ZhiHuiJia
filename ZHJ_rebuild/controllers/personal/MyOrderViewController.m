//
//  MyOrderViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyOrderViewController.h"

//views
#import "SegmentTapView.h"
#import "FlipTableView.h"

//controllers
#import "OrderListViewController.h"

@interface MyOrderViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipView;

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initSegment];
    [self initFlipTableView];
    
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


#pragma mark - <添加segmentView>
-(void)initSegment{
    self.segmentView = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40) withDataArray:[NSArray arrayWithObjects:@"全部",@"待付款",@"待发货",@"已发货",@"待评价", nil] withFont:15];
    self.segmentView.delegate = self;
    [self.view addSubview:self.segmentView];
//    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.left.right.mas_equalTo(0);
////        make.height.mas_equalTo(40);
//        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
}

#pragma mark - <添加flipTableView>
-(void)initFlipTableView{
    OrderListViewController *allOrderVC = [[OrderListViewController alloc]initWithNibName:NSStringFromClass([OrderListViewController class]) bundle:nil];
    OrderListViewController *waitToPayVC = [[OrderListViewController alloc]initWithNibName:NSStringFromClass([OrderListViewController class]) bundle:nil];
    OrderListViewController *waitToSendoutVC = [[OrderListViewController alloc]initWithNibName:NSStringFromClass([OrderListViewController class]) bundle:nil];
    OrderListViewController *sendedGoodsVC = [[OrderListViewController alloc]initWithNibName:NSStringFromClass([OrderListViewController class]) bundle:nil];
    OrderListViewController *waitToCommentVC = [[OrderListViewController alloc]initWithNibName:NSStringFromClass([OrderListViewController class]) bundle:nil];
    
    NSMutableArray *vcArray = [NSMutableArray array];
    [vcArray addObject:allOrderVC];
    [vcArray addObject:waitToPayVC];
    [vcArray addObject:waitToSendoutVC];
    [vcArray addObject:sendedGoodsVC];
    [vcArray addObject:waitToCommentVC];
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 40, kSCREEN_WIDTH, self.view.frame.size.height-40-64) withArray:vcArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
    
//    __weak typeof(self) weakSelf = self;
//    [self.flipView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(weakSelf.segmentView).with.offset(0);
//        make.right.left.bottom.mas_equalTo(0);
//    }];
    
    //根据上一个页面传过来的selectedIndex确定当前segmentView的选中页面
    [self.segmentView selectIndex:self.selectedIndex];
}














#pragma mark - ** SegmentTapViewDelegate ***
-(void)selectedIndex:(NSInteger)index
{
    [self.flipView selectIndex:index];
}

#pragma mark - ** FlipTableViewDelegate ***
-(void)scrollChangeToIndex:(NSInteger)index
{
    [self.segmentView selectIndex:index];
}



@end
