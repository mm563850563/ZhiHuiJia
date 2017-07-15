//
//  HomePageViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/5.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "HomePageViewController.h"

//categate
#import "UIImage+Color.h"

//controllers
#import "NotificationViewController.h"
#import "ProductDetailViewController.h"

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

@interface HomePageViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,CycleScrollViewCellDelegate>

@property (nonatomic, strong)UISearchBar *searchBarHomePage;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

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
    
    [self settingNavigationBar];
    [self getTestData];
    [self initTableView];
    [self addSearchBarIntoNavigationBar];
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

#pragma mark - <获取数据>
-(void)getTestData
{
    UIImage *img1 = [UIImage imageNamed:@"huantu"];
    UIImage *img2 = [UIImage imageNamed:@"huantu"];
    UIImage *img3 = [UIImage imageNamed:@"huantu"];
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
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"左按钮" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"右按钮" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToNotificationVC)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //设置navigationBar背景图
    UIColor *color = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0];
    UIImage *image = [UIImage imageWithColor:color];
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
            cell = cellYouthColor;
        }else if (indexPath.row == 2){
            UITableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:@"more"];
            cellMore.textLabel.text = @"更多新品>";
            cellMore.textLabel.textAlignment = 1;
            cellMore.textLabel.font = [UIFont systemFontOfSize:13];
            cell = cellMore;
        }
    }else if (indexPath.section == 9){//数码新生活
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
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            return 300;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 1) {
            return 300;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 5){
            return 40;
        }else{
            return kSCREEN_WIDTH/2.0;
        }
    }else if (indexPath.section == 4){
        if (indexPath.row == 1) {
            return 300;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 5){
        if (indexPath.row == 1) {
            return 300;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 6){
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 4){
            return 40;
        }else{
            return kSCREEN_WIDTH/2.0;
        }
    }else if (indexPath.section == 7){
        if (indexPath.row == 1) {
            return 300;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 8){
        if (indexPath.row == 1) {
            return 300;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 9){
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 5){
            return 40;
        }else{
            return kSCREEN_WIDTH/2.0;
        }
    }else if (indexPath.section == 10){
        if (indexPath.row == 1) {
            return 300;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 11){
        if (indexPath.row == 1) {
            return 300;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 12){
        if (indexPath.row == 1) {
            return 300;
        }else if (indexPath.row == 2){
            return 40;
        }
    }else if (indexPath.section == 13){
        return 300;
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
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = [UIColor redColor];
        return headerView;
    }
    return nil;
}



#pragma mark - ****** UINavigationControllerDelegate *******
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[NotificationViewController class]]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else if ([viewController isKindOfClass:[self class]]){
        navigationController.navigationBar.translucent = YES;
        [navigationController setNavigationBarHidden:NO animated:YES];
    }else{
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

//#pragma mark - **  **
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    
//}

#pragma mark - ***** UIScrollViewDelegate ******
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //根据scrollView的偏移量使navigationBar的背景色渐变
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat alpha = offsetY/(100.0);
    UIColor *color = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:alpha];
    UIImage *image = [UIImage imageWithColor:color];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}


#pragma mark - ****** CycleScrollViewCellDelegate *******
-(void)cycleScrollViewCell:(CycleScrollViewCell *)cycleScrollViewCell didSelectItemAtIndex:(NSInteger)index
{
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:@"ProductDetailViewController" bundle:nil];
    productDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}







@end
