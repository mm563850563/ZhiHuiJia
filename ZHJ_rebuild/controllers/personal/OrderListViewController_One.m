//
//  OrderListViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "OrderListViewController_One.h"

//cells
#import "OrderListCell.h"

//views
#import "OrderListHeaderView.h"
#import "OrderListFooterView.h"

//models
#import "OrderListModel.h"
#import "OrderList_OrderListModel.h"
#import "OrderListGoodsModel.h"

@interface OrderListViewController_One ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *orderListArray;
@property (nonatomic, strong)NSArray *goodsArray;
@property (nonatomic, strong)NSNumber *page;

@end

@implementation OrderListViewController_One

#pragma mark - <懒加载>
-(NSMutableArray *)orderListArray
{
    if (!_orderListArray) {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = [NSNumber numberWithInt:1];
    [self getOrderListData];
    [self initTableView];
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

#pragma mark - <获取订单列表数据>
-(void)getOrderListData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kOrderList];
    
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"order_type":@"all"};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSError *error = nil;
            OrderListModel *model = [[OrderListModel alloc]initWithDictionary:dataDict error:&error];
            if (!error) {
                if ([model.code isEqualToString:@"200"]) {
                    self.orderListArray = [NSMutableArray arrayWithArray:model.data.result.order_list];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                        [hudWarning hideAnimated:YES afterDelay:2.0];
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.localizedDescription];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
}










#pragma mark - <初始化tableView>
-(void)initTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 100;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([OrderListCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([OrderListCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page_int = [self.page intValue];
        page_int++;
        self.page = [NSNumber numberWithInt:page_int];
    }];
}












#pragma mark - **** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderListArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderList_OrderListModel *modelOrderList = self.orderListArray[section];
    self.goodsArray = modelOrderList.goods;
    return self.goodsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    /*
     0 => '待确认',
     1 => '已确认',
     2 => '已收货',
     3 => '已取消',
     4 => '已完成',//评价完
     5 => '已作废',
     */
    OrderList_OrderListModel *modelOrderList = self.orderListArray[section];
    OrderListHeaderView *headerView  = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([OrderListHeaderView class]) owner:nil options:nil].lastObject;
    headerView.labelOrderCode.text = modelOrderList.order_sn;
    headerView.labelOrderState.text = modelOrderList.order_status_desc;
    
//    if ([modelOrderList.order_status isEqualToString:@"0"]) {
//        headerView.labelOrderState.text = @"待付款";
//    }else if ([modelOrderList.order_status isEqualToString:@"1"]){
//        headerView.labelOrderState.text = @"已付款";
//    }else if ([modelOrderList.order_status isEqualToString:@"2"]){
//        headerView.labelOrderState.text = @"已收货";
//    }else if ([modelOrderList.order_status isEqualToString:@"3"]){
//        headerView.labelOrderState.text = @"交易关闭";
//    }else if ([modelOrderList.order_status isEqualToString:@"4"]){
//        headerView.labelOrderState.text = @"已完成";
//    }else if ([modelOrderList.order_status isEqualToString:@"5"]){
//        headerView.labelOrderState.text = @"已作废";
//    }
//
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderList_OrderListModel *modelOrderList = self.orderListArray[section];
    OrderListFooterView *footerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([OrderListFooterView class]) owner:nil options:nil].lastObject;
    footerView.modelOrderList = modelOrderList;
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderList_OrderListModel *modelOrderList = self.orderListArray[indexPath.section];
    self.goodsArray = modelOrderList.goods;
    OrderListGoodsModel *modelGoods = self.goodsArray[indexPath.row];
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderListCell class])];
    cell.modelGoods = modelGoods;
    return cell;
}



@end
