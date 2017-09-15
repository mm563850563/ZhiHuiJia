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
#import "OrderListViewController_One.h"
#import "OrderListViewController_Two.h"
#import "OrderListViewController_Three.h"
#import "OrderListViewController_Four.h"
#import "OrderListViewController_Five.h"
#import "CommentViewController.h"

#import "OrderList_OrderListModel.h"

@interface MyOrderViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate,MBProgressHUDDelegate>

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipView;

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingNavigation];
    [self initSegment];
    [self initFlipTableView];
    
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

#pragma mark - <配置navigation>
-(void)settingNavigation
{
    self.navigationItem.title = @"我的订单";
}

#pragma mark - <添加segmentView>
-(void)initSegment{
    self.segmentView = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40) withDataArray:[NSArray arrayWithObjects:@"全部",@"待付款",@"待发货",@"待收货",@"待评价", nil] withFont:15];
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
    OrderListViewController_One *allOrderVC = [[OrderListViewController_One alloc]initWithNibName:NSStringFromClass([OrderListViewController_One class]) bundle:nil];
    OrderListViewController_Two *waitToPayVC = [[OrderListViewController_Two alloc]initWithNibName:NSStringFromClass([OrderListViewController_Two class]) bundle:nil];
    OrderListViewController_Three *waitToSendoutVC = [[OrderListViewController_Three alloc]initWithNibName:NSStringFromClass([OrderListViewController_Three class]) bundle:nil];
    OrderListViewController_Four *sendedGoodsVC = [[OrderListViewController_Four alloc]initWithNibName:NSStringFromClass([OrderListViewController_Four class]) bundle:nil];
    OrderListViewController_Five *waitToCommentVC = [[OrderListViewController_Five alloc]initWithNibName:NSStringFromClass([OrderListViewController_Five class]) bundle:nil];
    
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
    [self.flipView selectIndex:self.selectedIndex-1];
}

#pragma mark - <取消订单请求>
-(void)requestCancelOrderWithOrderID:(NSString *)order_id;
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kCancelOrder];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"order_id":order_id};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.navigationController.view animated:YES];
    hud.delegate = self;
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
        
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
}

#pragma mark - <跳转“评论”页面>
-(void)jumpToCommentVCWithModel:(OrderList_OrderListModel *)model
{
    CommentViewController *commentVC = [[CommentViewController alloc]initWithNibName:NSStringFromClass([CommentViewController class]) bundle:nil];
    commentVC.modelOrderList = model;
    commentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //响应“取消订单”
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"cancelOrder" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *order_id = x.object;
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"取消订单？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requestCancelOrderWithOrderID:order_id];
        }];
        UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:actionYES];
        [alertVC addAction:actionNO];
        [self presentViewController:alertVC animated:YES completion:nil];
    }];
    
    //推出评论页面
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"presentCommentView" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        OrderList_OrderListModel *model = x.object;
        [self jumpToCommentVCWithModel:model];
    }];
    
    
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

#pragma mark - ***** MBProgressHUDDelegate *****
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAllOrderAndPayOrder" object:nil];
}

@end
