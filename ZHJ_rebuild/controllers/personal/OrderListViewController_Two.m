//
//  OrderListViewController_Two.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/16.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "OrderListViewController_Two.h"

//cells
#import "OrderListCell.h"
#import "NULLTableViewCell.h"

//views
#import "OrderListHeaderView.h"
#import "OrderListFooterView.h"

//models
#import "OrderListModel.h"
#import "OrderList_OrderListModel.h"
#import "OrderListGoodsModel.h"


@interface OrderListViewController_Two ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *orderListArray;
@property (nonatomic, strong)NSArray *goodsArray;
@property (nonatomic, strong)NSNumber *page;

@end

@implementation OrderListViewController_Two

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
                                    @"order_type":@"pay"};
    
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSError *error = nil;
            OrderListModel *model = [[OrderListModel alloc]initWithDictionary:dataDict error:&error];
            if (!error) {
                if ([model.code isEqualToString:@"200"]) {
                    self.orderListArray = [NSMutableArray arrayWithArray:model.data.result.order_list];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES afterDelay:1.0];
                        [self.tableView reloadData];
                        [self.tableView.mj_header endRefreshing];
                        [self.tableView.mj_footer endRefreshing];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES afterDelay:1.0];
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                        [hudWarning hideAnimated:YES afterDelay:2.0];
                        
                        [self.tableView.mj_header endRefreshing];
                        [self.tableView.mj_footer endRefreshing];
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.localizedDescription];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark - <获取更多订单列表数据>
-(void)getMoreOrderListDataWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kOrderList];
    
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"page":page,
                                    @"order_type":@"pay"};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSError *error = nil;
            OrderListModel *model = [[OrderListModel alloc]initWithDictionary:dataDict error:&error];
            if (!error) {
                if ([model.code isEqualToString:@"200"]) {
                    NSArray *array = [NSMutableArray arrayWithArray:model.data.result.order_list];
                    for (OrderList_OrderListModel *model in array) {
                        [self.orderListArray addObject:model];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        [self.tableView.mj_header endRefreshing];
                        [self.tableView.mj_footer endRefreshing];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                        [hudWarning hideAnimated:YES afterDelay:2.0];
                        
                        [self.tableView.mj_header endRefreshing];
                        [self.tableView.mj_footer endRefreshing];
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.localizedDescription];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
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
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getOrderListData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page_int = [self.page intValue];
        page_int++;
        self.page = [NSNumber numberWithInt:page_int];
        [self getMoreOrderListDataWithPage:self.page];
    }];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"refreshAllOrderAndPayOrder" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self getOrderListData];
    }];
}










#pragma mark - **** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.orderListArray.count>0) {
        return self.orderListArray.count;
    }else{
        return 1;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.orderListArray.count>0) {
        OrderList_OrderListModel *modelOrderList = self.orderListArray[section];
        self.goodsArray = modelOrderList.goods;
        return self.goodsArray.count;
    }else{
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.orderListArray.count == 0) {
        return 0.1f;
    }
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.orderListArray.count == 0) {
        return 0.1f;
    }
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderListArray.count>0) {
        return 100;
    }else{
        return self.view.frame.size.height;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.orderListArray.count == 0) {
        return nil;
    }
    OrderList_OrderListModel *modelOrderList = self.orderListArray[section];
    OrderListHeaderView *headerView  = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([OrderListHeaderView class]) owner:nil options:nil].lastObject;
    headerView.labelOrderCode.text = modelOrderList.order_sn;
    headerView.labelOrderState.text = @"待付款";
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.orderListArray.count == 0) {
        return nil;
    }
    OrderList_OrderListModel *modelOrderList = self.orderListArray[section];
    OrderListFooterView *footerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([OrderListFooterView class]) owner:nil options:nil].lastObject;
    modelOrderList.order_status_desc = @"待支付";
    footerView.modelOrderList = modelOrderList;
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderListArray.count == 0) {
        NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        return cellNull;
    }
    OrderList_OrderListModel *modelOrderList = self.orderListArray[indexPath.section];
    self.goodsArray = modelOrderList.goods;
    OrderListGoodsModel *modelGoods = self.goodsArray[indexPath.row];
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderListCell class])];
    cell.modelGoods = modelGoods;
    return cell;
}

@end