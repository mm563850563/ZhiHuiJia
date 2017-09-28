//
//  BrandDetailViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "BrandDetailViewController.h"

//cells
#import "BrandDetailHeaderCell.h"
#import "BrandDetailCell.h"

//views
#import "SegmentTapView.h"

//models
#import "BrandDetailModel.h"
#import "BrandDetail_BrandGoodsModel.h"
#import "BrandDetail_BrandDetailModel.h"

//controllers
#import "ProductDetailViewController.h"

@interface BrandDetailViewController ()<SegmentTapViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)UIView *headerView;

@property (nonatomic, strong)BrandDetail_BrandDetailModel *modelBrandDetail;
@property (nonatomic, strong)NSMutableArray *brandGoodsArray;
@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, strong)NSNumber *page;

@end

@implementation BrandDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = [NSNumber numberWithInt:1];
    
    NSDictionary *dictParameter = @{@"brand_id":self.brand_id,
                                    @"sort":@"recommend"};
    [self getBrandDetailDataWithDictParameter:dictParameter];
    [self initHeaderView];
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
-(NSMutableArray *)brandGoodsArray
{
    if (!_brandGoodsArray) {
        _brandGoodsArray = [NSMutableArray array];
    }
    return _brandGoodsArray;
}

#pragma mark - <品牌详情>
-(void)getBrandDetailDataWithDictParameter:(NSDictionary *)dictPara
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kBrandDetail];
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:YES params:dictPara progressBlock:nil successBlock:^(id response) {
        
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            BrandDetailModel *model = [[BrandDetailModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                self.modelBrandDetail = model.data.result.brand_detail;
                self.brandGoodsArray = [NSMutableArray arrayWithArray:model.data.result.brand_goods];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    int page_int = [self.page intValue];
                    page_int++;
                    self.page = [NSNumber numberWithInt:page_int];
                    [self.tableView reloadData];
                    [hud hideAnimated:YES afterDelay:1.0];
                    self.tableView.delegate = self;
                    self.tableView.dataSource = self;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    [hud hideAnimated:YES afterDelay:1.0];
                });
                
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
                [hud hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
            [hud hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <初始化headerView>
-(void)initHeaderView
{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    NSArray *titles = @[@"全部商品",@"品牌故事"];
    self.segmentView = [[SegmentTapView alloc]initWithFrame:self.headerView.bounds withDataArray:titles withFont:14];
    self.segmentView.delegate = self;
    [self.headerView addSubview:self.segmentView];
}

#pragma mark - <settingTableView>
-(void)settingTableView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.f;
    
    UINib *nibHeader = [UINib nibWithNibName:NSStringFromClass([BrandDetailHeaderCell class]) bundle:nil];
    [self.tableView registerNib:nibHeader forCellReuseIdentifier:NSStringFromClass([BrandDetailHeaderCell class])];
    
    [self.tableView registerClass:[BrandDetailCell class] forCellReuseIdentifier:NSStringFromClass([BrandDetailCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self getMoreBrandDetailDataWithPage:self.page];
    }];
}


#pragma mark - <获取更多数据>
-(void)getMoreBrandDetailDataWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kBrandDetail];
    NSDictionary *dictParameter = @{@"brand_id":self.brand_id,
                                    @"page":page};
    
//    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:YES params:dictParameter progressBlock:nil successBlock:^(id response) {
//        [hud hideAnimated:YES afterDelay:1.0];
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            BrandDetailModel *model = [[BrandDetailModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                self.modelBrandDetail = model.data.result.brand_detail;
                NSArray *array = [NSArray arrayWithArray:model.data.result.brand_goods];
                if (array.count > 0) {
                    for (BrandDetail_BrandGoodsModel *modelGoods in array) {
                        [self.brandGoodsArray addObject:modelGoods];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    int page_int = [self.page intValue];
                    page_int++;
                    self.page = [NSNumber numberWithInt:page_int];
                    [self.tableView reloadData];
//                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView.mj_footer endRefreshing];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    [self.tableView.mj_footer endRefreshing];
//                    [hud hideAnimated:YES afterDelay:1.0];
                });
                
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
                [self.tableView.mj_footer endRefreshing];
//                [hud hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
            [self.tableView.mj_footer endRefreshing];
//            [hud hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <跳转“商品详情”页面>
-(void)jumpToProductDetailVCWithGoodsID:(NSString *)goods_id
{
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:NSStringFromClass([ProductDetailViewController class]) bundle:nil];
    productDetailVC.goods_id = goods_id;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}



#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"switchFlip_AllProduct_BrandStory" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSNumber *indexNum = x.object;
        NSInteger index = [indexNum integerValue];
        [self.segmentView selectIndex:index];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_recommed" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSDictionary *dictParameter = @{@"brand_id":self.brand_id,
                                        @"sort":@"recommend"};
        [self getBrandDetailDataWithDictParameter:dictParameter];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_newest" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UIButton *button = x.object;
        NSDictionary *dictParameter = [NSDictionary dictionary];
        if (button.selected) {
            dictParameter = @{@"brand_id":self.brand_id,
                              @"sort":@"lastest",
                              @"value":@"1"};
        }else{
            dictParameter = @{@"brand_id":self.brand_id,
                              @"sort":@"lastest",
                              @"value":@"0"};
        }
        [self getBrandDetailDataWithDictParameter:dictParameter];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_salesVolunm" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UIButton *button = x.object;
        NSDictionary *dictParameter = [NSDictionary dictionary];
        if (button.selected) {
            dictParameter = @{@"brand_id":self.brand_id,
                              @"sort":@"sales",
                              @"value":@"1"};
        }else{
            dictParameter = @{@"brand_id":self.brand_id,
                              @"sort":@"sales",
                              @"value":@"0"};
        }
        [self getBrandDetailDataWithDictParameter:dictParameter];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_price" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UIButton *button = x.object;
        NSDictionary *dictParameter = [NSDictionary dictionary];
        if (button.selected) {
            dictParameter = @{@"brand_id":self.brand_id,
                              @"sort":@"price",
                              @"value":@"1"};
        }else{
            dictParameter = @{@"brand_id":self.brand_id,
                              @"sort":@"price",
                              @"value":@"0"};
        }
        [self getBrandDetailDataWithDictParameter:dictParameter];
    }];
    
    //跳转“商品详情”页面
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToProductDetailVCFromBrandDetailVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *goods_id = (NSString *)x.object;
        [self jumpToProductDetailVCWithGoodsID:goods_id];
    }];
}












#pragma mark - ****** UITableViewDelegate,UITableViewDataSource *******
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section ==0) {
        BrandDetailHeaderCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BrandDetailHeaderCell class])];
        cellHeader.model = self.modelBrandDetail;
        cell = cellHeader;
    }else
    {
        BrandDetailCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BrandDetailCell class])];
        cellNormal.modelBrandDetail = self.modelBrandDetail;
        cellNormal.dataArray = self.brandGoodsArray;
        cell = cellNormal;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == 0) {
        return 0.1f;
//    }else{
//        return 50;
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 1) {
        return self.headerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 270;
    }else{
        BrandDetailCell *cellNormal = [[BrandDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([BrandDetailCell class])];
        cellNormal.dataArray = self.brandGoodsArray;
        return cellNormal.cellHeight;
    }
}

#pragma mark - *** SegmentTapViewDelegate ****
-(void)selectedIndex:(NSInteger)index
{
    NSNumber *indexNum = [NSNumber numberWithInteger:index];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"switchSegment_AllProduct_BrandStory" object:indexNum];
}

@end
