//
//  DiscoverViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/10.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DiscoverViewController.h"

//views
#import "SegmentTapView.h"
#import "FlipTableView.h"

//cells
#import "DiscoverHeaderCell.h"
#import "DiscoverCell.h"

//controllers
#import "DynamicDetailViewController.h"
#import "MainCircleViewController.h"
#import "SameTownViewController.h"
#import "DomainViewController.h"
#import "NotificationViewController.h"

@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SegmentTapViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)UITableView *mainTableView;

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipView;


@end

@implementation DiscoverViewController

#pragma mark - <懒加载>

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavigation];
    [self initMianTableView];
    
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

#pragma mark - <配置navigation>
-(void)settingNavigation
{
    self.navigationController.delegate = self;
    UIColor *color = kColorFromRGBAndAlpha(kThemeYellow, 1.0);
    UIImage *image = [UIImage imageWithColor:color height:1.0];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self addSearchBarIntoNavigationBar];
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
    searchBar.placeholder = @"查找话题或用户";
    self.navigationItem.titleView = searchBar;
}


#pragma mark - <初始化mainTableView>
-(void)initMianTableView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.mainTableView.estimatedRowHeight = 80.0f;
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    
    
    UINib *nibHeaderCell = [UINib nibWithNibName:NSStringFromClass([DiscoverHeaderCell class]) bundle:nil];
    [self.mainTableView registerNib:nibHeaderCell forCellReuseIdentifier:NSStringFromClass([DiscoverHeaderCell class])];
    
    UINib *nibDiscoverCell = [UINib nibWithNibName:NSStringFromClass([DiscoverCell class]) bundle:nil];
    [self.mainTableView registerNib:nibDiscoverCell forCellReuseIdentifier:NSStringFromClass([DiscoverCell class])];
}

#pragma mark - <响应RAC>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"Discover_Flip" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSNumber *num = x.object;
        NSInteger index = [num integerValue];
        [self.segmentView selectIndex:index];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"didSelectDynamicItem" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSIndexPath *indexPath = x.object;
        DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc]initWithNibName:NSStringFromClass([DynamicDetailViewController class]) bundle:nil];
        dynamicDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dynamicDetailVC animated:YES];
    }];
    
    //点击圈子
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"clickCircleAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        MainCircleViewController *mainCircleVC = [[MainCircleViewController alloc]initWithNibName:NSStringFromClass([MainCircleViewController class]) bundle:nil];
        mainCircleVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mainCircleVC animated:YES];
    }];
    
    //点击同城
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"clickSameTownAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        SameTownViewController *sameTownVC = [[SameTownViewController alloc]initWithNibName:NSStringFromClass([SameTownViewController class]) bundle:nil];
        sameTownVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sameTownVC animated:YES];
    }];
    
    //点击地盘
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"clickDomainAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        DomainViewController *domainVC = [[DomainViewController alloc]initWithNibName:NSStringFromClass([DomainViewController class]) bundle:nil];
        domainVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:domainVC animated:YES];
    }];
    
}






#pragma mark - *** UINavigationControllerDelegate ******
//-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    
//}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[DomainViewController class]]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else if ([viewController isKindOfClass:[NotificationViewController class]]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - ****** SegmentTapViewDelegate *******
-(void)selectedIndex:(NSInteger)index
{
    NSNumber *indexNum = [NSNumber numberWithInteger:index];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Discover_Segment" object:indexNum];
}

#pragma mark - ********* UITableViewDelegate,UITableViewDataSource ********
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 320;
    }
    return 2500;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        DiscoverHeaderCell *cell1 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DiscoverHeaderCell class])];
        cell = cell1;
    }else{
        DiscoverCell *cell2 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DiscoverCell class])];
        cell = cell2;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    if (section == 1) {
        //segmentView
        NSArray *titleArray = @[@"精选动态",@"热门话题",@"活动推荐"];
        self.segmentView = [[SegmentTapView alloc]initWithFrame:headerView.bounds withDataArray:titleArray withFont:14];
        self.segmentView.delegate = self;
        [headerView addSubview:self.segmentView];
        [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
