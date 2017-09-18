//
//  OrderListViewController_Two.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/16.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "OrderListViewController_Two.h"

//AliPay
#import <AlipaySDK/AlipaySDK.h>
//WechatPay
#import "WXApi.h"

//cells
#import "OrderListCell.h"
#import "NULLTableViewCell.h"

//views
#import "OrderListHeaderView.h"
#import "OrderListFooterView.h"
#import "PayTypeView.h"

//models
#import "OrderListModel.h"
#import "OrderList_OrderListModel.h"
#import "OrderListGoodsModel.h"

#import "PlaceOrderModel.h"
#import "PlaceOrderAliPayModel.h"
#import "PlaceOrderWeChatPayModel.h"
#import "PalceOrderOrderInfoModel.h"
#import "PlaceOrderCallbackModel.h"
#import "PlaceOrderBalanceModel.h"

//controllers
#import "SuccessPayViewController.h"

//tools
#import "ShareTool.h"

//SDKs
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>


@interface OrderListViewController_Two ()<UITableViewDelegate,UITableViewDataSource,PayTypeViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *orderListArray;
@property (nonatomic, strong)NSArray *goodsArray;
@property (nonatomic, strong)NSNumber *page;

@property (nonatomic, strong)UIView *payTypeBurView;

@property (nonatomic,strong)OrderList_OrderListModel *modelOrderList;

//支付宝支付串码
@property (nonatomic, strong)NSString *pay_code;
//微信支付订单号
@property (nonatomic, strong)NSString *order_sn;
@property (nonatomic, strong)NSDictionary *payParameter;

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

#pragma mark - <获取待支付信息>
-(void)getOrderPayInfoWithOrderID:(NSString *)order_id
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetOrderPayInfo];
    
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"order_id":order_id};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                NSDictionary *dictResult = dataDict[@"data"][@"result"];
                NSString *total_price = dictResult[@"total_price"];
                NSString *deduction = dictResult[@"deduction"];
                NSString *payables = dictResult[@"payables"];
                NSDictionary *dict = [NSDictionary dictionary];
                if (total_price && deduction && payables){
                    dict = @{@"total_price":total_price,
                                           @"deduction":deduction,
                                           @"payables":payables};
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self popPayTypeViewWithFeeDetail:dict];
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
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
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

#pragma mark - <付款With支付宝>
-(void)getRepayOrderDataWithAliPayWithPayParameter:(NSDictionary *)dictParameter
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kOrderRepay];
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSError *error = nil;
            PlaceOrderModel *model = [[PlaceOrderModel alloc]initWithDictionary:dataDict error:&error];
            if (!error) {
                if ([model.code isEqualToString:@"200"]) {
                    PlaceOrderAliPayModel *modelAliPay = model.data.result.aliPay;
                    self.pay_code = modelAliPay.pay_code;
                    
                    //支付串码不为空就调支付宝
                    if (![self.pay_code isEqualToString:@""]) {
                        NSString *scheme = @"ZhiHuiJia";
                        [[AlipaySDK defaultService]payOrder:self.pay_code fromScheme:scheme callback:^(NSDictionary *resultDic) {
                            NSString *resultStatus = resultDic[@"resultStatus"];
                            if ([resultStatus isEqualToString:@"9000"]) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [hud hideAnimated:YES afterDelay:1.0];
                                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"支付成功"];
                                    [hudWarning hideAnimated:YES afterDelay:1.0];
                                    
                                    hudWarning.completionBlock = ^{
                                        [self getOrderListData];
                                        [self.payTypeBurView removeFromSuperview];
                                        [self jumpToSuccessPayVCWithAliModel:modelAliPay];
                                    };
                                });
                                
                                
                            }else{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [hud hideAnimated:YES afterDelay:1.0];
                                    [self.navigationController popViewControllerAnimated:YES];
                                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"支付失败"];
                                    [hudWarning hideAnimated:YES afterDelay:1.0];
                                    
                                    hudWarning.completionBlock = ^{
                                        [self.payTypeBurView removeFromSuperview];
                                    };
                                });
                                
                            }
                        }];
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hud hideAnimated:YES afterDelay:1.0];
                            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                            [hudWarning hideAnimated:YES afterDelay:1.0];
                            hudWarning.completionBlock = ^{
                                [self.payTypeBurView removeFromSuperview];
                            };
                        });
                        
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES afterDelay:1.0];
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                        [hudWarning hideAnimated:YES afterDelay:1.0];
                        hudWarning.completionBlock = ^{
                            [self.payTypeBurView removeFromSuperview];
                        };
                    });
                    
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.localizedDescription];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    hudWarning.completionBlock = ^{
                        [self.payTypeBurView removeFromSuperview];
                    };
                });
                
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
                hudWarning.completionBlock = ^{
                    [self.payTypeBurView removeFromSuperview];
                };
            });
            
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
            hudWarning.completionBlock = ^{
                [self.payTypeBurView removeFromSuperview];
            };
        });
        
    }];
}

#pragma mark - <付款With微信>
-(void)getRepayOrderDataWithWechatWithPayParameter:(NSDictionary *)dictParameter
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kOrderRepay];
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            PlaceOrderModel *model = [[PlaceOrderModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                [hud hideAnimated:YES afterDelay:1.0];
                PlaceOrderCallbackModel *modelCallback = model.data.result.wxPay.callback;
                PalceOrderOrderInfoModel *modelOrderInfo = model.data.result.wxPay.order_info;
                self.order_sn = modelOrderInfo.order_sn;
                
                PayReq *payreq = [[PayReq alloc]init];
                payreq.partnerId = modelCallback.partnerid;
                payreq.package = modelCallback.package;
                payreq.prepayId = modelCallback.prepayid;
                payreq.sign = modelCallback.sign;
                payreq.timeStamp = (UInt32)[modelCallback.timestamp intValue];
                payreq.nonceStr = modelCallback.noncestr;
                
                if (![WXApi isWXAppInstalled]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请安装微信"];
                        [hudWarning hideAnimated:YES afterDelay:1.0];
                    });
                    
                }else if (![WXApi isWXAppSupportApi]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"不支持微信支付"];
                        [hudWarning hideAnimated:YES afterDelay:1.0];
                    });
                }else{
                    [WXApi sendReq:payreq];
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
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

#pragma mark - <微信支付回调二次请求>
-(void)verifyWXPayResult
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kVerifyPayResult];
    if (![self.order_sn isEqualToString:@""]) {
        NSDictionary *dictParameter = @{@"order_sn":self.order_sn,
                                        @"user_id":kUserDefaultObject(kUserInfo)};
        
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                NSNumber *code = dataDict[@"code"];
                if ([code isEqual:@200]) {
                    NSError *error = nil;
                    PalceOrderOrderInfoModel *modelWXPay = [[PalceOrderOrderInfoModel alloc]initWithDictionary:dataDict[@"data"][@"result"] error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getOrderListData];
                        [hud hideAnimated:YES afterDelay:1.0];
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                        [hudWarning hideAnimated:YES afterDelay:1.0];
                        hudWarning.completionBlock = ^{
                            [self jumpToSuccessPayVCWithWXModel:modelWXPay];
                            [self.payTypeBurView removeFromSuperview];
                        };
                        
                    });
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES afterDelay:1.0];
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                        [hudWarning hideAnimated:YES afterDelay:1.0];
                        hudWarning.completionBlock = ^{
                            [self.payTypeBurView removeFromSuperview];
                        };
                        
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.payTypeBurView removeFromSuperview];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
        } failBlock:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                [self.payTypeBurView removeFromSuperview];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
            
        }];
    }
}

#pragma mark - <打开世界大门-支付宝>
-(void)jumpToSuccessPayVCWithAliModel:(PlaceOrderAliPayModel *)modelAliPay
{
    SuccessPayViewController *successPayVC = [[SuccessPayViewController alloc]initWithNibName:NSStringFromClass([SuccessPayViewController class]) bundle:nil];
    successPayVC.modelAli = modelAliPay;
    [self presentViewController:successPayVC animated:YES completion:nil];
}

#pragma mark - <打开世界大门-微信>
-(void)jumpToSuccessPayVCWithWXModel:(PalceOrderOrderInfoModel *)modelWechat
{
    SuccessPayViewController *successPayVC = [[SuccessPayViewController alloc]initWithNibName:NSStringFromClass([SuccessPayViewController class]) bundle:nil];
    successPayVC.modelWX = modelWechat;
    [self presentViewController:successPayVC animated:YES completion:nil];
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

#pragma mark - <弹出@“选择支付”页面>
-(void)popPayTypeViewWithFeeDetail:(NSDictionary *)feeDetail
{
    
    NSString *total_price = feeDetail[@"total_price"];
    NSString *deduction = feeDetail[@"deduction"];
    NSString *payables = feeDetail[@"payables"];
    
    self.payTypeBurView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.payTypeBurView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPaytypeBGViewActionWithTap:)];
    [self.payTypeBurView addGestureRecognizer:tap];
    
    [self.payTypeBurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.payTypeBurView.backgroundColor = kColorFromRGBAndAlpha(0x000000, 0.7);
    
    PayTypeView *payTypeView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([PayTypeView class]) owner:nil options:nil].lastObject;
    payTypeView.feeDetail = [NSString stringWithFormat:@"订单总价为%@元,你的余额为%@元,本次需支付%@元",total_price,deduction,payables];
    payTypeView.delegate = self;
    [self.payTypeBurView addSubview:payTypeView];
    
    [payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

#pragma mark - <支付背景点击事件>
-(void)tapPaytypeBGViewActionWithTap:(UITapGestureRecognizer *)tap
{
    [self.payTypeBurView removeFromSuperview];
}

#pragma mark - <第三方分享-配置要分享的参数>
-(void)settingShareParameter
{
    //1.创建分享参数 注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    UIImage *image = [UIImage imageNamed:@"appLogo"];
    NSArray *imageArray = @[image];
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"1亿礼品库,注册必送礼！" images:imageArray url:[NSURL URLWithString:kZHJAppStoreLink] title:@"智惠加" type:SSDKContentTypeAuto];
        
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        //2.分享（可以弹出我们的分享菜单和编辑界面）
        [ShareTool shareWithParams:shareParams];
    }
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"refreshAllOrderAndPayOrder" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self getOrderListData];
    }];
    
    //付款
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"clickBtnPayFromWaitToPayVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        OrderList_OrderListModel *modelOrderList = x.object;
        self.modelOrderList = modelOrderList;
        [self getOrderPayInfoWithOrderID:modelOrderList.order_id];
        
        self.payParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                              @"order_id":modelOrderList.order_id,
                              @"pay_type":@"1"};
    }];
    
    //微信回调二次请求
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"WX_PaySuccess" object:nil] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        [self verifyWXPayResult];
    }];
    
    //分享
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"clickBtnShareFromWaitToPayVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
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
    footerView.whereReuseFrom = @"waitToPayVC";
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

#pragma mark - ******* PayTypeViewDelegate *******
-(void)didSelectPayType:(NSString *)payType
{
    if ([payType isEqualToString:@"1"]) {
        self.payParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                              @"order_id":self.modelOrderList.order_id,
                              @"pay_type":@"1"};
    }else if([payType isEqualToString:@"2"]){
        self.payParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                              @"order_id":self.modelOrderList.order_id,
                              @"pay_type":@"2"};
    }
    
}

-(void)didClickConfirmWithButton:(UIButton *)button
{
    NSString *pay_type = self.payParameter[@"pay_type"];
    if ([pay_type isEqualToString:@"1"]) {
        [self getRepayOrderDataWithAliPayWithPayParameter:self.payParameter];
    }else if ([pay_type isEqualToString:@"2"]){
        [self getRepayOrderDataWithWechatWithPayParameter:self.payParameter];
    }
    
}

@end
