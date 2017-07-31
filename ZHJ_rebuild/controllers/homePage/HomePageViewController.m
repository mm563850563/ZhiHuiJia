//
//  HomePageViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/5.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "HomePageViewController.h"



//controllers
#import "NotificationViewController.h"
#import "PersonalFileViewController.h"
#import "ProductDetailViewController.h"
#import "MoreProductListViewController.h"
#import "PYSearchViewController.h"
#import "FocusPersonFileViewController.h"
#import "GetGiftViewController.h"
#import "SameHobbyPersonListViewController.h"
#import "DynamicDetailViewController.h"
#import "ShakeAndWinViewController.h"

//cells
//#import "BaseTableViewCell.h"
//#import "FactoryTableViewCell.h"
#import "CycleScrollViewCell.h"
#import "GiftSendingTableViewCell.h"
#import "HomePageMainCell.h"
#import "YouthColorCell.h"//青春色彩大的tableViewCell
#import "HomeLeftImageCell.h"
#import "HomeRightImageCell.h"
#import "IntellectWearsCell.h"//智能穿戴大的tableViewCell
#import "SameHobbyCell.h"//发现同趣的人的大cell

//models
#import "HomeGoodsModel.h"
#import "HomeGoodsResultModel.h"
#import "IndexCarouselModel.h"
#import "IndexCarouselResultModel.h"

@interface HomePageViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,CycleScrollViewCellDelegate,UISearchBarDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)UISearchBar *searchBarHomePage;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSArray *carouselResultArray;
@property (nonatomic, strong)NSArray *homeGoodsResultArray;

@end

@implementation HomePageViewController

#pragma mark - <懒加载>
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self managerRequestWithGCD];
//    [self getIndexCarouselData];
//    [self getHomeGoodsData];
    [self settingNavigationBar];
    [self initTableView];
    [self addSearchBarIntoNavigationBar];
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

//-(void)viewWillAppear:(BOOL)animated
//{
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.translucent = YES;
//}

#pragma mark - <GCD管理多线程>
-(void)managerRequestWithGCD
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.navigationController.view animated:YES];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue1 = dispatch_queue_create("getIndexCarousel", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("getHomeGoods", NULL);
    
    dispatch_group_async(group, queue1, ^{
        [self getIndexCarouselData];
    });
    dispatch_group_async(group, queue2, ^{
        [self getHomeGoodsData];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [hud hideAnimated:YES afterDelay:1.0];
    });
}

#pragma mark - <获取轮播图数据>
-(void)getIndexCarouselData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kIndexCarousel];
//    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.navigationController.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:YES params:nil progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            IndexCarouselModel *model = [[IndexCarouselModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToNumber:[NSNumber numberWithInteger:200]]) {
                self.carouselResultArray = model.data.result;
                //回到主线程刷新数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    //开始加载首页产品数据
//                    [self getHomeGoodsDataWithHUD:hud];
                });
            }else{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hideAnimated:YES afterDelay:1.0];
//            });
        }
    } failBlock:^(NSError *error) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:error.description];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }];
}

#pragma mark - <获取主页产品数据>
-(void)getHomeGoodsData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kHomeGoods];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:YES params:nil progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            HomeGoodsModel *model = [[HomeGoodsModel alloc]initWithDictionary:dataDict error:nil];
            
            if ([model.code isEqualToNumber:[NSNumber numberWithInteger:200]]) {
                self.homeGoodsResultArray = model.data.result;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        }
    } failBlock:^(NSError *error) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:error.description];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }];
}


#pragma mark - <初始化tableView>
-(void)initTableView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:backView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.navigationController.view.frame.size.height-44) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"more"];
    
    [self.tableView registerClass:[CycleScrollViewCell class] forCellReuseIdentifier:NSStringFromClass([IndexCarouselModel class])];
    
    UINib *nibGiftSending = [UINib nibWithNibName:NSStringFromClass([GiftSendingTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibGiftSending forCellReuseIdentifier:NSStringFromClass([GiftSendingTableViewCell class])];
    
    UINib *nibHomeMain = [UINib nibWithNibName:NSStringFromClass([HomePageMainCell class]) bundle:nil];
    [self.tableView registerNib:nibHomeMain forCellReuseIdentifier:NSStringFromClass([HomePageMainCell class])];
    
    [self.tableView registerClass:[YouthColorCell class] forCellReuseIdentifier:NSStringFromClass([YouthColorCell class])];
    
    UINib *nibLeftImage = [UINib nibWithNibName:NSStringFromClass([HomeLeftImageCell class]) bundle:nil];
    [self.tableView registerNib:nibLeftImage forCellReuseIdentifier:NSStringFromClass([HomeLeftImageCell class])];
    
    UINib *nibRightImage = [UINib nibWithNibName:NSStringFromClass([HomeRightImageCell class]) bundle:nil];
    [self.tableView registerNib:nibRightImage forCellReuseIdentifier:NSStringFromClass([HomeRightImageCell class])];
    
    [self.tableView registerClass:[IntellectWearsCell class] forCellReuseIdentifier:NSStringFromClass([IntellectWearsCell class])];
    
    [self.tableView registerClass:[SameHobbyCell class] forCellReuseIdentifier:NSStringFromClass([SameHobbyCell class])];
}

#pragma mark - <配置navigationBar>
-(void)settingNavigationBar
{
    self.navigationController.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIView *leftButtonView = [self createLeftNavigationButton];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(jumpToNotificationVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //设置navigationBar背景图
    UIColor *color = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0];
    UIImage *image = [UIImage imageWithColor:color height:1.0];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - <创建左按钮>
-(UIView *)createLeftNavigationButton
{
    UIView *BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"appLogo"]];
    imgView.frame = CGRectMake(10, 0, 30, 30);
    [BGView addSubview:imgView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 50, 10)];
    label.text = @"因你而不同";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:9];
    [BGView addSubview:label];
    
    BGView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToPersonalFileVC)];
    [BGView addGestureRecognizer:tap];
    
    return BGView;
}

#pragma mark - <添加searchBar到navigationBar>
-(void)addSearchBarIntoNavigationBar
{
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.delegate = self;
    UIColor *color = kColorFromRGBAndAlpha(kWhite, 1.0);
    UIImage *image = [UIImage imageWithColor:color height:30.0];
    [searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"搜索";
    self.navigationItem.titleView = searchBar;
    self.searchBarHomePage = searchBar;
}

#pragma mark - <跳转NotificationViewController>
-(void)jumpToNotificationVC
{
    NotificationViewController *notificationVC = [[NotificationViewController alloc]init];
    notificationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notificationVC animated:YES];
}
#pragma mark - <跳转个人资料页面>
-(void)jumpToPersonalFileVC
{
    PersonalFileViewController *personalFileVC = [[PersonalFileViewController alloc]initWithNibName:NSStringFromClass([PersonalFileViewController class]) bundle:nil];
    personalFileVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalFileVC animated:YES];
}
#pragma mark - <跳转产品详情页面>
-(void)jumpToProductDetailVC
{
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:NSStringFromClass([ProductDetailViewController class]) bundle:nil];
    productDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}
#pragma mark - <跳转更多产品页面>
-(void)jumpToMoreProductListVC
{
    MoreProductListViewController *moreProductListVC = [[MoreProductListViewController alloc]init];
    moreProductListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreProductListVC animated:YES];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //点击同趣的人
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"SameHobbyCell"object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        FocusPersonFileViewController *focusPersonFileVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
        focusPersonFileVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:focusPersonFileVC animated:YES];
    }];
    
    //点击”拿好礼“按钮
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"RegisterGiftAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UIButton *button = x.object;
        GetGiftViewController *getGiftVC = [[GetGiftViewController alloc]initWithNibName:NSStringFromClass([GetGiftViewController class]) bundle:nil];
        getGiftVC.hidesBottomBarWhenPushed = YES;
        getGiftVC.category = button.tag;
        [self.navigationController pushViewController:getGiftVC animated:YES];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"ShareGiftAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UIButton *button = x.object;
        GetGiftViewController *getGiftVC = [[GetGiftViewController alloc]initWithNibName:NSStringFromClass([GetGiftViewController class]) bundle:nil];
        getGiftVC.hidesBottomBarWhenPushed = YES;
        getGiftVC.category = button.tag;
        [self.navigationController pushViewController:getGiftVC animated:YES];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"BuyGiftAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UIButton *button = x.object;
        GetGiftViewController *getGiftVC = [[GetGiftViewController alloc]initWithNibName:NSStringFromClass([GetGiftViewController class]) bundle:nil];
        getGiftVC.hidesBottomBarWhenPushed = YES;
        getGiftVC.category = button.tag;
        [self.navigationController pushViewController:getGiftVC animated:YES];
    }];
    
    //点击YouthColorCell中的item
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectYouthItem" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSIndexPath *indePath = x.object;
        [self jumpToProductDetailVC];
    }];
}







#pragma mark - ******** UITableViewDataSource,UITableViewDelegate ********
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.homeGoodsResultArray.count + 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSInteger sectionCount = 3;
//    if (section < 12) {
//        HomeGoodsResultModel *model = self.homeGoodsResultArray[section];
//        NSString *modelID = model.id;
//        if ([modelID isEqualToString:@"1"] || [modelID isEqualToString:@"4"] || [modelID isEqualToString:@"8"]) {
//            sectionCount = model.goods_list.count;
//        }
//    }
//    
//    if (section == 0) {
//        return 2;
//    }else if (section == 13){
//        return 1;
//    }else if (section == 14){
//        return 2;
//    }
//    return sectionCount;
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CycleScrollViewCell *cycleCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IndexCarouselModel class])];
            cycleCell.delegate = self;
            cycleCell.carouselModels = self.carouselResultArray;
            cell = cycleCell;
        }else if (indexPath.row == 1){
            GiftSendingTableViewCell *giftCell = [tableView dequeueReusableCellWithIdentifier:@"GiftSendingTableViewCell"];
            cell = giftCell;
        }
    }else if (indexPath.section == 1){//青春色彩
        if (indexPath.row == 0) {
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cell = cellHomeMain;
        }else if (indexPath.row == 1){
            YouthColorCell *cellYouthColor = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YouthColorCell class])];
            cellYouthColor.numberOfCell = 6;
            cell = cellYouthColor;
        }else if (indexPath.row == 2){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多新品>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }
    }else if (indexPath.section == 2){//智能出行
        if (indexPath.row == 0) {
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cell = cellHomeMain;
        }else if (indexPath.row == 1){
            YouthColorCell *cellYouthColor = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YouthColorCell class])];
            cellYouthColor.numberOfCell = 6;
            cell = cellYouthColor;
        }else if (indexPath.row == 2){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多新品>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }
    }else if (indexPath.section == 3){//智能健康
        if (indexPath.row == 0) {
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cell = cellHomeMain;
        }else if (indexPath.row == 5){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多新品>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }else{
            if (indexPath.row%2 == 1) {
                HomeLeftImageCell *cellLeftImage = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeLeftImageCell class])];
                cell = cellLeftImage;
            }else{
                HomeRightImageCell *cellRightImage = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeRightImageCell class])];
                cell = cellRightImage;
            }
        }
    }else if (indexPath.section == 4){//智能穿戴
        if (indexPath.row == 0) {
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cell = cellHomeMain;
        }else if (indexPath.row == 1){
            IntellectWearsCell *cellIntellectWears = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IntellectWearsCell class])];
            cellIntellectWears.numberOfCell = 6;
            cell = cellIntellectWears;
        }else if (indexPath.row == 2){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多新品>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }
    }else if (indexPath.section == 5){//智能娱乐
        if (indexPath.row == 0) {
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cell = cellHomeMain;
        }else if (indexPath.row == 1){
            YouthColorCell *cellYouthColor = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YouthColorCell class])];
            cellYouthColor.numberOfCell = 6;
            cell = cellYouthColor;
        }else if (indexPath.row == 2){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多新品>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }
    }else if (indexPath.section == 6){//智能生活
        if (indexPath.row == 0) {
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cell = cellHomeMain;
        }else if (indexPath.row == 5){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多新品>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }else{
            if (indexPath.row%2 == 1) {
                HomeLeftImageCell *cellLeftImage = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeLeftImageCell class])];
                cell = cellLeftImage;
            }else{
                HomeRightImageCell *cellRightImage = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeRightImageCell class])];
                cell = cellRightImage;
            }
        }
    }else if (indexPath.section == 7){//电脑周边
        if (indexPath.row == 0) {
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cell = cellHomeMain;
        }else if (indexPath.row == 1){
            IntellectWearsCell *cellIntellectWears = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IntellectWearsCell class])];
            cellIntellectWears.numberOfCell = 6;
            cell = cellIntellectWears;
        }else if (indexPath.row == 2){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多新品>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }
    }else if (indexPath.section == 8){//手机周边
        if (indexPath.row == 0) {
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cell = cellHomeMain;
        }else if (indexPath.row == 1){
            YouthColorCell *cellYouthColor = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YouthColorCell class])];
            cellYouthColor.numberOfCell = 6;
            cell = cellYouthColor;
        }else if (indexPath.row == 2){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多新品>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }
    }else if (indexPath.section == 9){//数码新科技
        if (indexPath.row == 0) {
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cell = cellHomeMain;
        }else if (indexPath.row == 5){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多新品>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }else{
            if (indexPath.row%2 == 1) {
                HomeLeftImageCell *cellLeftImage = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeLeftImageCell class])];
                cell = cellLeftImage;
            }else{
                HomeRightImageCell *cellRightImage = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeRightImageCell class])];
                cell = cellRightImage;
            }
        }
    }else if (indexPath.section == 10){//创意潮品
        if (indexPath.row == 0) {
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cell = cellHomeMain;
        }else if (indexPath.row == 1){
            YouthColorCell *cellYouthColor = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YouthColorCell class])];
            cellYouthColor.numberOfCell = 6;
            cell = cellYouthColor;
        }else if (indexPath.row == 2){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多新品>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }
    }else if (indexPath.section == 11){//大牌低价专区
        if (indexPath.row == 0) {
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cell = cellHomeMain;
        }else if (indexPath.row == 1){
            YouthColorCell *cellYouthColor = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YouthColorCell class])];
            cellYouthColor.numberOfCell = 6;
            cell = cellYouthColor;
        }else if (indexPath.row == 2){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多新品>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }
    }else if (indexPath.section == 12){//品质生活
        if (indexPath.row == 0) {
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cell = cellHomeMain;
        }else if (indexPath.row == 1){
            YouthColorCell *cellYouthColor = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YouthColorCell class])];
            cellYouthColor.numberOfCell = 6;
            cell = cellYouthColor;
        }else if (indexPath.row == 2){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多新品>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }
    }else if (indexPath.section == 13){//为你精心推荐
        YouthColorCell *cellYouthColor = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YouthColorCell class])];
        cellYouthColor.numberOfCell = 6;
        cell = cellYouthColor;
    }else if (indexPath.section == 14){//发现同趣的人
        if (indexPath.row == 0) {
            SameHobbyCell *cellSameHobby = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SameHobbyCell class])];
            cell = cellSameHobby;
        }else if (indexPath.row == 1){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多同趣的人>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }
    }
    
    if (indexPath.section > 0 && indexPath.section < self.homeGoodsResultArray.count+1) {
        
        if (indexPath.row == 0) {
            HomeGoodsResultModel *model = self.homeGoodsResultArray[indexPath.section-1];
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cellHomeMain.imgString = model.big_img.image;
            cell = cellHomeMain;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {//青春色彩
        if (indexPath.row == 1) {
            CGFloat cellHeight = kSCREEN_WIDTH/2.0/2.0*3.0*3;
            return cellHeight;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 2){//智能出行
        if (indexPath.row == 1) {
            CGFloat cellHeight = kSCREEN_WIDTH/2.0/2.0*3.0*3;
            return cellHeight;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 3){//智能健康
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 5){
            return 40;
        }else{
            return kSCREEN_WIDTH/2.0;
        }
    }else if (indexPath.section == 4){//智能穿戴
        if (indexPath.row == 1) {
            CGFloat cellHeight = kSCREEN_WIDTH/2.0/2.0*3.0*3;
            return cellHeight;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 5){//智能娱乐
        if (indexPath.row == 1) {
            CGFloat cellHeight = kSCREEN_WIDTH/2.0/2.0*3.0*3;
            return cellHeight;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 6){//智能生活
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 5){
            return 40;
        }else{
            return kSCREEN_WIDTH/2.0;
        }
    }else if (indexPath.section == 7){//电脑周边
        if (indexPath.row == 1) {
            CGFloat cellHeight = kSCREEN_WIDTH/2.0/2.0*3.0*3;
            return cellHeight;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 8){//手机周边
        if (indexPath.row == 1) {
            CGFloat cellHeight = kSCREEN_WIDTH/2.0/2.0*3.0*3;
            return cellHeight;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 9){//数码新科技
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 5){
            return 40;
        }else{
            return kSCREEN_WIDTH/2.0;
        }
    }else if (indexPath.section == 10){//创意潮品
        if (indexPath.row == 1) {
            CGFloat cellHeight = kSCREEN_WIDTH/2.0/2.0*3.0*3;
            return cellHeight;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 11){//大牌低价专区
        if (indexPath.row == 1) {
            CGFloat cellHeight = kSCREEN_WIDTH/2.0/2.0*3.0*3;
            return cellHeight;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 12){//品质生活
        if (indexPath.row == 1) {
            CGFloat cellHeight = kSCREEN_WIDTH/2.0/2.0*3.0*3;
            return cellHeight;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 13){//为您精心推荐
        CGFloat cellHeight = kSCREEN_WIDTH/2.0/2.0*3.0*3;
        return cellHeight;
    }else if (indexPath.section == 14){
        if (indexPath.row == 0) {
            return 230;
        }else if (indexPath.row == 1){
            return 40;
        }
    }
    
    CGFloat height = kSCREEN_WIDTH/5.2*3.0;
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > self.homeGoodsResultArray.count) {
        return 50;
    }
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 14) {
        return 20;
    }
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    headerView.backgroundColor = [UIColor purpleColor];
    UILabel *label = [[UILabel alloc]initWithFrame:headerView.bounds];
    label.textColor = kColorFromRGB(kWhite);
    [headerView addSubview:label];
    if (section == self.homeGoodsResultArray.count + 1) {
        label.text = @"为你精心推荐";
        return headerView;
    }
    if (section == self.homeGoodsResultArray.count + 2) {
        label.text = @"发现同趣的人";
        return headerView;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self jumpToProductDetailVC];
        }
    }else if (indexPath.section == 13){
        return;
    }else if (indexPath.section == 14){
        if (indexPath.row == 1) {
            SameHobbyPersonListViewController *sameHobbyPersonListVC = [[SameHobbyPersonListViewController alloc]initWithNibName:NSStringFromClass([SameHobbyPersonListViewController class]) bundle:nil];
            sameHobbyPersonListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sameHobbyPersonListVC animated:YES];
        }
    }else{
        if (indexPath.section == 3 || indexPath.section == 6 || indexPath.section == 9) {
            if (indexPath.row == 5) {
                [self jumpToMoreProductListVC];
            }else{
                [self jumpToProductDetailVC];
            }
        }else{
            if (indexPath.row == 0) {
                [self jumpToProductDetailVC];
            }else if (indexPath.row == 2){
                [self jumpToMoreProductListVC];
            }
        }
    }
}



#pragma mark - ****** UINavigationControllerDelegate *******
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[NotificationViewController class]]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }
    else if ([viewController isKindOfClass:[self class]]){
        [navigationController.navigationBar setTranslucent:YES];
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
    else if ([viewController isKindOfClass:[FocusPersonFileViewController class]]){
        [navigationController.navigationBar setTranslucent:YES];
        [navigationController setNavigationBarHidden:YES animated:YES];
    }
    else if ([viewController isKindOfClass:[GetGiftViewController class]]){
        [navigationController.navigationBar setTranslucent:YES];
        [navigationController setNavigationBarHidden:YES animated:YES];
    }
    else if ([viewController isKindOfClass:[DynamicDetailViewController class]]){
        [navigationController.navigationBar setTranslucent:NO];
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
    else if ([viewController isKindOfClass:[SameHobbyPersonListViewController class]]){
        [navigationController.navigationBar setTranslucent:NO];
        [navigationController setNavigationBarHidden:NO animated:YES];
    }else if ([viewController isKindOfClass:[FocusPersonFileViewController class]]){
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else if ([viewController isKindOfClass:[ProductDetailViewController class]]){
        [navigationController.navigationBar setTranslucent:NO];
        [navigationController setNavigationBarHidden:NO animated:YES];
    }else if ([viewController isKindOfClass:[ShakeAndWinViewController class]]){
        [navigationController.navigationBar setTranslucent:NO];
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - ***** UIScrollViewDelegate ******
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //根据scrollView的偏移量使navigationBar的背景色渐变
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat alpha = offsetY/(100.0);
    UIColor *color = kColorFromRGBAndAlpha(kThemeYellow, alpha);
    UIImage *image = [UIImage imageWithColor:color height:1.0];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - ****** CycleScrollViewCellDelegate *******
-(void)cycleScrollViewCell:(CycleScrollViewCell *)cycleScrollViewCell didSelectItemAtIndex:(NSInteger)index
{
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:@"ProductDetailViewController" bundle:nil];
    productDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

#pragma mark - **** UISearchBarDelegate ****
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSArray *array = @[@"杯子",@"背包",@"运动鞋",@"Nike",@"珠穆朗玛峰",@"约翰尼德普"];
    PYSearchViewController *searchVC = [PYSearchViewController searchViewControllerWithHotSearches:array searchBarPlaceholder:@"请输入关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        MoreProductListViewController *moreProductListVC = [[MoreProductListViewController alloc]init];
        [searchViewController.navigationController pushViewController:moreProductListVC animated:YES];
    }];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}




@end
