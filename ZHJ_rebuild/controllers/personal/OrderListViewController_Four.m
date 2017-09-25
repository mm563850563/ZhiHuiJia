//
//  OrderListViewController_Four.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/16.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "OrderListViewController_Four.h"

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

//tools
#import "ShareTool.h"

//SDKs
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

@interface OrderListViewController_Four ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *orderListArray;
@property (nonatomic, strong)NSArray *goodsArray;
@property (nonatomic, strong)NSNumber *page;

@end

@implementation OrderListViewController_Four

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

#pragma mark - <获取订单列表数据>
-(void)getOrderListData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kOrderList];
    
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"order_type":@"confirm"};
    
    
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
                        [hudWarning hideAnimated:YES afterDelay:1.0];
                        
                        [self.tableView.mj_header endRefreshing];
                        [self.tableView.mj_footer endRefreshing];
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.localizedDescription];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
                [hudWarning hideAnimated:YES afterDelay:1.0];
                
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
            
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
                                    @"order_type":@"confirm"};
    
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
                        [hudWarning hideAnimated:YES afterDelay:1.0];
                        
                        [self.tableView.mj_header endRefreshing];
                        [self.tableView.mj_footer endRefreshing];
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.localizedDescription];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
                [hudWarning hideAnimated:YES afterDelay:1.0];
                
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark - <确认收货>
-(void)getConfirmReceiptDataWithOrderID:(NSString *)order_id
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kConfirmReceipt];
    
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"order_id":order_id};
    
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //操作数组删除时不推荐forin
                    [self.orderListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        OrderList_OrderListModel *model = (OrderList_OrderListModel *)obj;
                        if ([model.order_id isEqualToString:order_id]) {
                            [self.orderListArray removeObject:model];
                        }
                    }];
//                    for (OrderList_OrderListModel *model in self.orderListArray) {
//                        if ([model.order_id isEqualToString:order_id]) {
//                            [self.orderListArray removeObject:model];
//                        }
//                    }
                    [self.tableView reloadData];
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
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

#pragma mark - <第三方分享-配置要分享的参数>
-(void)settingShareParameter
{
    //1.创建分享参数 注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    UIImage *image = [UIImage imageNamed:@"appLogo"];
    NSArray *imageArray = @[image];
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"全球首个爆品推荐+智慧社交平台！1亿礼品库、注册必送礼！" images:imageArray url:[NSURL URLWithString:kZHJAppStoreLink] title:@"智惠加" type:SSDKContentTypeAuto];
        
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        //2.分享（可以弹出我们的分享菜单和编辑界面）
        [ShareTool shareWithParams:shareParams];
    }
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //确认收货
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"confirmReceipt" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *order_id = x.object;
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确认收货?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getConfirmReceiptDataWithOrderID:order_id];
        }];
        [alertVC addAction:actionCancel];
        [alertVC addAction:actionConfirm];
        [self presentViewController:alertVC animated:YES completion:nil];
    }];
    
    //查看物流
    
    
    //分享
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"clickBtnShareFromSendedGoodsVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        [self settingShareParameter];
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
    headerView.labelOrderState.text = @"待收货";
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.orderListArray.count == 0) {
        return nil;
    }
    OrderList_OrderListModel *modelOrderList = self.orderListArray[section];
    OrderListFooterView *footerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([OrderListFooterView class]) owner:nil options:nil].lastObject;
    modelOrderList.order_status_desc = @"待收货";
    footerView.modelOrderList = modelOrderList;
    footerView.whereReuseFrom = @"sendedGoodsVC";
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
