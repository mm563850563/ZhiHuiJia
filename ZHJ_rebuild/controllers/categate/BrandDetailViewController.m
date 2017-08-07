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
    
    [self getBrandDetailDataWithSort_sales:@"0" sort_price:@"0" sort_lastest:@"0" sort_recommend:@"1" page:@"1"];
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
-(void)getBrandDetailDataWithSort_sales:(NSString *)sort_sales sort_price:(NSString *)sort_price sort_lastest:(NSString *)sort_lastest sort_recommend:(NSString *)sort_recommend page:(NSString *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kBrandDetail];
    NSDictionary *dictParameter = @{@"brand_id":self.brand_id,
                                    @"sort_sales":sort_sales,
                                    @"sort_price":sort_price,
                                    @"sort_lastest":sort_lastest,
                                    @"page":page};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:YES params:dictParameter progressBlock:nil successBlock:^(id response) {
        [hud hideAnimated:YES afterDelay:1.0];
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            BrandDetailModel *model = [[BrandDetailModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                self.modelBrandDetail = model.data.result.brand_detail;
                self.brandGoodsArray = [NSMutableArray arrayWithArray:model.data.result.brand_goods];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    self.tableView.delegate = self;
                    self.tableView.dataSource = self;
                });
            }else{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        }
    } failBlock:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:1.0];
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
        [hudWarning hideAnimated:YES afterDelay:2.0];
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
        int page_int = [self.page intValue];
        page_int++;
        self.page = [NSNumber numberWithInt:page_int];
        [self getMoreBrandDetailDataWithPage:self.page];
    }];
}


#pragma mark - <获取更多数据>
-(void)getMoreBrandDetailDataWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kBrandDetail];
    NSDictionary *dictParameter = @{@"brand_id":self.brand_id,
                                    @"page":page};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:YES params:dictParameter progressBlock:nil successBlock:^(id response) {
        [hud hideAnimated:YES afterDelay:1.0];
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
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                });
            }else{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        }
    } failBlock:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:1.0];
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }];
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
        [self getBrandDetailDataWithSort_sales:@"0" sort_price:@"0" sort_lastest:@"0" sort_recommend:@"1" page:@"1"];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_newest" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self getBrandDetailDataWithSort_sales:@"0" sort_price:@"0" sort_lastest:@"1" sort_recommend:@"1" page:@"1"];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_salesVolunm" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self getBrandDetailDataWithSort_sales:@"1" sort_price:@"0" sort_lastest:@"0" sort_recommend:@"1" page:@"1"];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"sort_price" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self getBrandDetailDataWithSort_sales:@"0" sort_price:@"1" sort_lastest:@"0" sort_recommend:@"1" page:@"1"];
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
