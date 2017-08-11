//
//  CartViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/10.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CartViewController.h"

//views
#import "SSCheckBoxView.h"

//cells
#import "CartProductListCell.h"
#import "YouthColorCell.h"

//controllers
#import "ProductDetailViewController.h"
#import "OrderConfirmViewController.h"

//models
#import "CartListModel.h"
#import "CartList_CartListModel.h"
#import "CartListTotalPriceModel.h"
#import "CartListAllSelectedModel.h"
#import "EditCartNumberModel.h"
#import "UserFavoriteModel.h"
#import "UserFavoriteResultModel.h"

@interface CartViewController ()<UITableViewDelegate,UITableViewDataSource,CartProductListCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelCutPrice;
@property (weak, nonatomic) IBOutlet UIView *tableBGView;
@property (weak, nonatomic) IBOutlet UIView *checkBoxBGView;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmitOrDelete;
@property (nonatomic, strong)SSCheckBoxView *checkBox;

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *cartListArray;
@property (nonatomic, strong)NSMutableArray *userFavoriteArray;
@property (nonatomic, strong)NSMutableArray *removeCartArray;
@property (nonatomic, strong)CartListTotalPriceModel *modelTotalPrice;

@property (nonatomic, assign)BOOL isEdit;
@property (nonatomic, strong)NSNumber *page;

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = [NSNumber numberWithInt:1];
//    [self getUserFavoriteData];
    [self managerRequestWithGCD];
    [self settingNavigationBar];
    [self settingOutlets];
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

#pragma mark - <懒加载>
-(NSMutableArray *)removeCartArray
{
    if (!_removeCartArray) {
        _removeCartArray = [NSMutableArray array];
    }
    return _removeCartArray;
}

-(NSMutableArray *)userFavoriteArray
{
    if (!_userFavoriteArray) {
        _userFavoriteArray = [NSMutableArray array];
    }
    return _userFavoriteArray;
}

#pragma mark - <设置navigationBar>
-(void)settingNavigationBar
{
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEdit.frame = CGRectMake(0, 0, 50, 30);
    [btnEdit setTitleColor:kColorFromRGB(kDeepGray) forState:UIControlStateNormal];
    btnEdit.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(btnEditAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editBarItem = [[UIBarButtonItem alloc]initWithCustomView:btnEdit];
    self.navigationItem.rightBarButtonItem = editBarItem;
}

#pragma mark - <编辑按钮响应>
-(void)btnEditAction:(UIButton *)sender
{
    self.isEdit = !self.isEdit;
    if (self.isEdit) {
        [self.btnSubmitOrDelete setTitle:@"删除" forState:UIControlStateNormal];
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        self.tableView.mj_footer.hidden = YES;
    }else{
        [self.btnSubmitOrDelete setTitle:@"去提交" forState:UIControlStateNormal];
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        self.tableView.mj_footer.hidden = NO;
    }
    
    [self.tableView reloadData];
}

#pragma mark - <通过GCD管理多线程请求>
-(void)managerRequestWithGCD
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue1 = dispatch_queue_create("getCartList", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("getUserFavorite", NULL);
    
    dispatch_group_async(group, queue1, ^{
        [self getCartListData];
    });
    dispatch_group_async(group, queue2, ^{
        [self getUserFavoriteData];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [hud hideAnimated:YES afterDelay:1.0];
    });
}


#pragma mark - <获取购物车列表数据>
-(void)getCartListData
{
    NSString *str = [NSString stringWithFormat:@"%@%@",kDomainBase,kCartList];
    NSDictionary *dictParameter = [NSDictionary dictionary];
    if (kUserDefaultObject(kUserInfo)) {
        NSString *userID = kUserDefaultObject(kUserInfo);
        dictParameter = @{@"user_id":userID};
    }
    
//    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:str refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
//        [hud hideAnimated:YES afterDelay:1.0];
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            CartListModel *model = [[CartListModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                self.cartListArray = model.data.result.cart_list;
                self.modelTotalPrice = model.data.result.total_price;
                [self sendDataToOutlets];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableArray *array = [NSMutableArray array];
                    for (CartList_CartListModel *modelCartList in self.cartListArray) {
                        if ([modelCartList.selected isEqualToString:@"0"]) {
                            self.checkBox.checked = NO;
                            [array addObject:modelCartList.selected];
                        }
                    }
                    if (array.count == 0) {
                        self.checkBox.checked = YES;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                });
            }else{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        }
    } failBlock:^(NSError *error) {
//        [hud hideAnimated:YES afterDelay:1.0];
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }];
}

#pragma mark - <听说你喜欢>
-(void)getUserFavoriteData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kUserFavorite];
    if (kUserDefaultObject(kUserInfo)) {
        NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
//        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                UserFavoriteModel *model = [[UserFavoriteModel alloc]initWithDictionary:dataDict error:nil];
                if ([model.code isEqualToString:@"200"]) {
//                    [hud hideAnimated:YES afterDelay:1.0];
//                    NSArray *array = model.data.result;
//                    if (array.count>0) {
//                        for (UserFavoriteResultModel *modelResult in array) {
//                            [self.userFavoriteArray addObject:modelResult];
//                        }
//                    }
                    self.userFavoriteArray = [NSMutableArray arrayWithArray:model.data.result];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }else{
//                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                }
            }else{
//                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"数据为空"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        } failBlock:^(NSError *error) {
//            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }];
    }
}

#pragma mark - <更多“听说你喜欢”>
-(void)getMoreUserFavoriteWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kUserFavorite];
    if (kUserDefaultObject(kUserInfo)) {
        NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                        @"page":page};
        //        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                UserFavoriteModel *model = [[UserFavoriteModel alloc]initWithDictionary:dataDict error:nil];
                if ([model.code isEqualToString:@"200"]) {
                    //                    [hud hideAnimated:YES afterDelay:1.0];
                    NSArray *array = model.data.result;
                    if (array.count>0) {
                        for (UserFavoriteResultModel *modelResult in array) {
                            [self.userFavoriteArray addObject:modelResult];
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        [self.tableView.mj_footer endRefreshing];
                    });
                }else{
                    //                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                }
            }else{
                //                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"数据为空"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        } failBlock:^(NSError *error) {
            //            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }];
    }
}

#pragma mark - <填充页面数据>
-(void)sendDataToOutlets
{
    self.labelTotalPrice.text = [NSString stringWithFormat:@"¥ %@",self.modelTotalPrice.total_fee];
    self.labelCutPrice.text = [NSString stringWithFormat:@"（已省¥ %@）",self.modelTotalPrice.cut_fee];
}


#pragma mark - <配置outlet>
-(void)settingOutlets
{
    self.checkBox = [[SSCheckBoxView alloc]initWithFrame:CGRectZero style:kSSCheckBoxViewStyleGreen checked:YES];
    [self.checkBoxBGView addSubview:self.checkBox];
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(30);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.checkBox.stateChangedBlock = ^(SSCheckBoxView *cbv) {
        if (weakSelf.checkBox.checked) {
            [weakSelf getCartListAllSelectedDataWith:@"1"];
        }else{
            [weakSelf getCartListAllSelectedDataWith:@"0"];
        }
        
    };
}

#pragma mark - <购物车列表单选>
-(void)getCartListSingleSelectedDataWithUser_id:(NSString *)userID cart_id:(NSString *)cartID selected:(NSString *)isSelected
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kChangeSelect];
    if (![userID isEqualToString:@""] || ![cartID isEqualToString:@""] || ![isSelected isEqualToString:@""]) {
        NSDictionary *dictParemeter = @{@"user_id":userID,
                                        @"cart_id":cartID,
                                        @"selected":isSelected};
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParemeter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                NSNumber *code = (NSNumber *)dataDict[@"code"];
                if ([code isEqual:@200]) {
                    [hud hideAnimated:YES afterDelay:1.0];
                    hud.completionBlock = ^{
                        [self getCartListData];
                    };
                }else{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                }
            }else{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"数据为空"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        } failBlock:^(NSError *error) {
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }];
    }
}

#pragma mark - <购物车列表全选>
-(void)getCartListAllSelectedDataWith:(NSString *)isAllSelected
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kCartListAllSelected];
    if (kUserDefaultObject(kUserInfo)) {
        NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                        @"select_all":isAllSelected};
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                CartListAllSelectedModel *model = [[CartListAllSelectedModel alloc]initWithDictionary:dataDict error:nil];
                if ([model.code isEqualToString:@"200"]) {
                    [hud hideAnimated:YES afterDelay:1.0];
                    hud.completionBlock = ^{
                        [self getCartListData];
                    };
                }
            }else{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"数据为空"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        } failBlock:^(NSError *error) {
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }];
    }
}

#pragma mark - <选择购物车产品的数量>
-(void)getChangeCartNumberDataWithUser_id:(NSString *)userID goods_num:(NSString *)goodsNum cart_id:(NSString *)cartID
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kEditCartNumber];
    if (![userID isEqualToString:@""] || ![cartID isEqualToString:@""] || ![goodsNum isEqualToString:@""]) {
        NSDictionary *dictParemeter = @{@"user_id":userID,
                                        @"cart_id":cartID,
                                        @"goods_num":goodsNum};
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParemeter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                EditCartNumberModel *model = [[EditCartNumberModel alloc]initWithDictionary:dataDict error:nil];
                if ([model.code isEqualToString:@"200"]) {
                    [hud hideAnimated:YES afterDelay:1.0];
                    self.labelTotalPrice.text = model.data.result.total_price;
                }else{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                }
            }else{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"数据为空"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        } failBlock:^(NSError *error) {
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }];
    }
}

#pragma mark - <删除购物车>
-(void)getRemoveCartDataWithRemoveCartArray:(NSMutableArray *)array
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kRemoveCart];
    if (kUserDefaultObject(kUserInfo)) {
        NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                        @"cart_id":array};
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                NSNumber *code = (NSNumber *)dataDict[@"code"];
                if ([code isEqual:@200]) {
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    //删除成功后重新请求刷新数据
                    hud.completionBlock = ^{
                        [self getCartListAfterRemoveCart];
                    };
                }else{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                }
            }else{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"数据为空"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        } failBlock:^(NSError *error) {
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }];
    }
}

#pragma mark - <删除购物车之后重新请求购物车列表刷新界面>
-(void)getCartListAfterRemoveCart
{
    NSString *str = [NSString stringWithFormat:@"%@%@",kDomainBase,kCartList];
    NSDictionary *dictParameter = [NSDictionary dictionary];
    if (kUserDefaultObject(kUserInfo)) {
        NSString *userID = kUserDefaultObject(kUserInfo);
        dictParameter = @{@"user_id":userID};
    }
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:str refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            CartListModel *model = [[CartListModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                self.cartListArray = model.data.result.cart_list;
                self.modelTotalPrice = model.data.result.total_price;
                [self sendDataToOutlets];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableArray *array = [NSMutableArray array];
                    for (CartList_CartListModel *modelCartList in self.cartListArray) {
                        if ([modelCartList.selected isEqualToString:@"0"]) {
                            self.checkBox.checked = NO;
                            [array addObject:modelCartList.selected];
                        }
                    }
                    if (array.count == 0) {
                        self.checkBox.checked = YES;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES afterDelay:1.0];
                        [self.tableView reloadData];
                    });
                });
            }else{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        }else{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"数据为空"];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }
    } failBlock:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:1.0];
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }];
}

#pragma mark - <初始化tableView>
-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.tableBGView.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kColorFromRGB(kLightGray);
    [self.tableBGView addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nibCartProductList = [UINib nibWithNibName:NSStringFromClass([CartProductListCell class]) bundle:nil];
    [self.tableView registerNib:nibCartProductList forCellReuseIdentifier:NSStringFromClass([CartProductListCell class])];
    
    [self.tableView registerClass:[YouthColorCell class] forCellReuseIdentifier:NSStringFromClass([YouthColorCell class])];
    
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page_int = [self.page intValue];
        page_int++;
        self.page = [NSNumber numberWithInt:page_int];
        [self getMoreUserFavoriteWithPage:self.page];
    }];
}

#pragma mark - <提交按钮／删除响应>
- (IBAction)btnSubmitOrDeleteAction:(UIButton *)sender
{
    if (self.isEdit) {
        //执行删除
        
        //先遍历所有购物车的selected属性
        for (CartList_CartListModel *modelList in self.cartListArray) {
            if ([modelList.selected isEqualToString:@"1"]) {
                [self.removeCartArray addObject:modelList.cart_id];
            }
        }
        [self getRemoveCartDataWithRemoveCartArray:self.removeCartArray];
    }else{
        //执行提交
        [self jumpToOrderConfirmVC];
    }
}

#pragma mark - <跳转产品详情页面>
-(void)jumpToProductDetailVCWithGoodsID:(NSString *)goods_id
{
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:NSStringFromClass([ProductDetailViewController class]) bundle:nil];
    productDetailVC.hidesBottomBarWhenPushed = YES;
    productDetailVC.goods_id = @"13";
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

#pragma mark - <跳转“确认订单页面”>
-(void)jumpToOrderConfirmVC
{
    OrderConfirmViewController *orderConfirmVC = [[OrderConfirmViewController alloc]initWithNibName:NSStringFromClass([OrderConfirmViewController class]) bundle:nil];
    orderConfirmVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderConfirmVC animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"refreshCartList" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self getCartListData];
    }];
    
    //点击YouthColorCell中的item
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectYouthItemByCartList" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *goods_id = x.object;
        [self jumpToProductDetailVCWithGoodsID:goods_id];
    }];
}















#pragma mark - ****** UITableViewDelegate,UITableViewDataSource *******
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isEdit) {
        return 1;
    }else{
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.cartListArray.count;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else{
        YouthColorCell *cell = [[YouthColorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([YouthColorCell class])];
        cell.userFavoriteArray = self.userFavoriteArray;
        return cell.cellHeight;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    return 30;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        CartProductListCell *cellCartProductList = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CartProductListCell class])];
        CartList_CartListModel *model = self.cartListArray[indexPath.row];
        cellCartProductList.model = model;
        cellCartProductList.btnCheckBox.tag = indexPath.row;
        cellCartProductList.btnIncrease.tag = indexPath.row;
        cellCartProductList.btnDecrease.tag = indexPath.row;
        cellCartProductList.delegate = self;
        cell = cellCartProductList;
    }else if (indexPath.section == 1){
        YouthColorCell *cellYouth = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YouthColorCell class])];
        cellYouth.userFavoriteArray = self.userFavoriteArray;
        cell = cellYouth;
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:headerView.bounds];
        imgView.image = [UIImage imageNamed:@"0youLike"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [headerView addSubview:imgView];
//        headerView.backgroundColor = [UIColor redColor];
        return headerView;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailViewController *prductDetaiVC = [[ProductDetailViewController alloc]init];
    CartList_CartListModel *model = self.cartListArray[indexPath.row];
    prductDetaiVC.goods_id = model.goods_id;
    prductDetaiVC.hidesBottomBarWhenPushed = YES;
    [self. navigationController pushViewController:prductDetaiVC animated:YES];
}




#pragma mark - ***** CartProductListCellDelegate ******
-(void)didClickCheckBoxButton:(UIButton *)sender isSelected:(NSString *)isSelected
{
    CartList_CartListModel *model = self.cartListArray[sender.tag];
    
    [self getCartListSingleSelectedDataWithUser_id:kUserDefaultObject(kUserInfo) cart_id:model.cart_id selected:isSelected];
}

-(void)didClickBtnChangeCartNumberWithButton:(UIButton *)sender productCount:(NSString *)productCount
{
    CartList_CartListModel *model = self.cartListArray[sender.tag];
    
    [self getChangeCartNumberDataWithUser_id:kUserDefaultObject(kUserInfo) goods_num:productCount cart_id:model.cart_id];
}





@end
