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
#import "CycleScrollModel.h"

@interface HomePageViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,CycleScrollViewCellDelegate,UISearchBarDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)UISearchBar *searchBarHomePage;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSArray *sectionTitleArray;

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

-(NSArray *)sectionTitleArray
{
    if (!_sectionTitleArray) {
        _sectionTitleArray = [[NSArray alloc]initWithObjects:@"青春色彩",@"智能出行",@"智能健康",@"智能穿戴",@"智能娱乐",@"智能生活",@"电脑周边",@"手机周边",@"数码新科技",@"创意潮品",@"大牌低价专区",@"品质生活",@"为您精心推荐",@"发现同趣的人", nil];
    }
    return _sectionTitleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavigationBar];
    [self getTestData];
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

#pragma mark - <获取数据>
-(void)getTestData
{
    UIImage *img1 = [UIImage imageNamed:@"fxdl"];
    UIImage *img2 = [UIImage imageNamed:@"fenxiangdali"];
    UIImage *img3 = [UIImage imageNamed:@"tongzzhi2"];
    NSArray *imgArray = @[img1,img2,img3];
    CycleScrollModel *model = [[CycleScrollModel alloc]init];
    model.arrayImage = imgArray;
    [self.dataArray addObject:model];
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
    
    [self.tableView registerClass:[CycleScrollViewCell class] forCellReuseIdentifier:NSStringFromClass([CycleScrollModel class])];
    
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
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"左按钮" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToPersonalFileVC)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"右按钮" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToNotificationVC)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //设置navigationBar背景图
    UIColor *color = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0];
    UIImage *image = [UIImage imageWithColor:color height:1.0];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - <添加searchBar到navigationBar>
-(void)addSearchBarIntoNavigationBar
{
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.delegate = self;
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
}







#pragma mark - ******** UITableViewDataSource,UITableViewDelegate ********
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 15;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 3){
        return 6;
    }else if (section == 6){
        return 5;
    }else if (section == 9){
        return 6;
    }else if (section == 13){
        return 1;
    }else if (section == 14){
        return 2;
    }
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //        CycleScrollModel *model = self.dataArray[0];
            //        BaseTableViewCell *baseCell = [FactoryTableViewCell createTableViewCellWithModel:model tableView:tableView indexPath:indexPath];
            //        [baseCell setDataWithModel:model];
            //        cell = baseCell;
            
            CycleScrollModel *model = self.dataArray[indexPath.row];
            CycleScrollViewCell *cycleCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CycleScrollModel class])];
            cycleCell.delegate = self;
            cycleCell.model = model;
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
        }else if (indexPath.row == 4){
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
            
        }else if (indexPath.row == 4){
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
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    return 50;
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
    if (section != 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        headerView.backgroundColor = [UIColor purpleColor];
        UILabel *label = [[UILabel alloc]initWithFrame:headerView.bounds];
        label.text = self.sectionTitleArray[section-1];
        label.textColor = kColorFromRGB(kWhite);
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        if (indexPath.section == 1) {
            if (indexPath.row == 2) {
                MoreProductListViewController *moreProductListVC = [[MoreProductListViewController alloc]init];
                moreProductListVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:moreProductListVC animated:YES];
            }
        }
    }else{
        ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:NSStringFromClass([ProductDetailViewController class]) bundle:nil];
        productDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
    
}



#pragma mark - ****** UINavigationControllerDelegate *******
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[NotificationViewController class]]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else if ([viewController isKindOfClass:[self class]]){
        navigationController.navigationBar.translucent = YES;
        [navigationController setNavigationBarHidden:NO animated:YES];
    }else if ([viewController isKindOfClass:[FocusPersonFileViewController class]]){
        [navigationController setNavigationBarHidden:YES];
    }else if ([viewController isKindOfClass:[GetGiftViewController class]]){
        [navigationController setNavigationBarHidden:YES animated:YES];
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
