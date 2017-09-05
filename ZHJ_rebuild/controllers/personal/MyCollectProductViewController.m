//
//  MyCollectProductViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyCollectProductViewController.h"

//cells
#import "MyCollectProductCell.h"
#import "YouthColorCell.h"
#import "NULLTableViewCell.h"

//models
#import "MyCollectionListDataModel.h"
#import "MyCollectionListResultModel.h"
#import "UserFavoriteModel.h"
#import "UserFavoriteResultModel.h"

//controllers
#import "ProductDetailViewController.h"

@interface MyCollectProductViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *collectionListArray;
@property (nonatomic, strong)NSMutableArray *userFavoriteArray;

@property (nonatomic, strong)NSNumber *page;

@end

@implementation MyCollectProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = @1;
    [self managerRequestWithGCD];
    [self settingTableView];
    
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
-(NSMutableArray *)userFavoriteArray
{
    if (!_userFavoriteArray) {
        _userFavoriteArray = [NSMutableArray array];
    }
    return _userFavoriteArray;
}


#pragma mark - <通过GCD管理多线程请求>
-(void)managerRequestWithGCD
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue1 = dispatch_queue_create("getCartList", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("getUserFavorite", NULL);
    
    dispatch_group_async(group, queue1, ^{
        [self getCollectionListData];
    });
    dispatch_group_async(group, queue2, ^{
        [self getUserFavoriteData];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [hud hideAnimated:YES afterDelay:1.0];
        [self.tableView.mj_header endRefreshing];
    });
}

#pragma mark - <获取“我的收藏”数据>
-(void)getCollectionListData
{
    NSString *str = [NSString stringWithFormat:@"%@%@",kDomainBase,kMyCollectionList];
    NSDictionary *dictParameter = [NSDictionary dictionary];
    if (kUserDefaultObject(kUserInfo)) {
        NSString *userID = kUserDefaultObject(kUserInfo);
        dictParameter = @{@"user_id":userID};
    }
    
    [YQNetworking postWithUrl:str refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                MyCollectionListDataModel  *modelData = [[MyCollectionListDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.collectionListArray = modelData.result;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
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

#pragma mark - <听说你喜欢>
-(void)getUserFavoriteData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kUserFavorite];
    if (kUserDefaultObject(kUserInfo)) {
        NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
        
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                UserFavoriteModel *model = [[UserFavoriteModel alloc]initWithDictionary:dataDict error:nil];
                if ([model.code isEqualToString:@"200"]) {
                    self.userFavoriteArray = [NSMutableArray arrayWithArray:model.data.result];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }else{ dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
                    
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"数据为空"];
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
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }];
    }
}

#pragma mark - <获取删除收藏数据>
-(void)getDeleteCollectionDataWithGoodsID:(NSString *)goods_id
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kDeleteCollection];
    NSDictionary *dictParameter = [NSDictionary dictionary];
    if (kUserDefaultObject(kUserInfo) || ![goods_id isEqualToString:@""]) {
        dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                          @"goods_id":goods_id};
    }
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        [hud hideAnimated:YES afterDelay:1.0];
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //重新刷新数据
                    [self getCollectionListData];
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
        
    }];
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([MyCollectProductCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([MyCollectProductCell class])];
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    [self.tableView registerClass:[YouthColorCell class] forCellReuseIdentifier:NSStringFromClass([YouthColorCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page_int = [self.page intValue];
        page_int++;
        self.page = [NSNumber numberWithInt:page_int];
        [self getMoreUserFavoriteWithPage:self.page];
    }];
}

#pragma mark - <跳转产品详情页面>
-(void)jumpToProductDetailVCWithGoodsID:(NSString *)goods_id
{
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:NSStringFromClass([ProductDetailViewController class]) bundle:nil];
    productDetailVC.hidesBottomBarWhenPushed = YES;
    productDetailVC.goods_id = goods_id;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}


#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //点击“删除”收藏
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"removeCollectionFromList" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *goods_id = x.object;
        [self getDeleteCollectionDataWithGoodsID:goods_id];
    }];
    
    //点击YouthColorCell中的item
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectYouthItemByCollectionList" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *goods_id = x.object;
        [self jumpToProductDetailVCWithGoodsID:goods_id];
    }];
}











#pragma mark - *** UITableViewDelete ,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.collectionListArray.count == 0) {
            return 1;
        }
        return self.collectionListArray.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.collectionListArray.count == 0) {
            return 250;
        }
        return 120;
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:headerView.bounds];
        imgView.image = [UIImage imageNamed:@"0youLike"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [headerView addSubview:imgView];
        return headerView;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        if (self.collectionListArray.count == 0) {
            NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
            return cellNull;
        }
        MyCollectProductCell *cellCollectionList = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyCollectProductCell class])];
        MyCollectionListResultModel *model = self.collectionListArray[indexPath.row];
        cellCollectionList.modelMyCollecgtionResult = model;
        cell = cellCollectionList;
    }else if (indexPath.section == 1){
        YouthColorCell *cellYouth = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YouthColorCell class])];
        cellYouth.userFavoriteArray = self.userFavoriteArray;
        cellYouth.fromWhere = @"myCollectionList";
        cell = cellYouth;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionListArray.count > 0) {
        if (indexPath.section == 0) {
            MyCollectionListResultModel *model = self.collectionListArray[indexPath.row];
            [self jumpToProductDetailVCWithGoodsID:model.goods_id];
        }
    }
}


@end
