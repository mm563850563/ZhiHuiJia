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
#import "DiscoverDynamicCell.h"

//models
#import "MyCircleDynamicDataModel.h"
#import "MyCircleDynamicResultModel.h"
#import "MyCircleDynamicTips_infoModel.h"

//controllers
#import "DynamicDetailViewController.h"
#import "MainCircleViewController.h"
#import "SameTownViewController.h"
#import "DomainViewController.h"
#import "NotificationViewController.h"
#import "ReleaseActivityViewController.h"

#import "DiscoverHotTopicViewController.h"
#import "DiscoverRecommendViewController.h"

#import "FocusPersonFileViewController.h"
#import "TopicDetailViewController.h"

@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SegmentTapViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)UITableView *mainTableView;
@property (nonatomic, strong)NSMutableArray *circleDynamicArray;

@property (nonatomic, strong)NSNumber *page;

@property (nonatomic, strong)SegmentTapView *segmentView;
@property (nonatomic, strong)FlipTableView *flipView;

@end

@implementation DiscoverViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = @1;
    [self getBestDynamicDataWithPage:@1];
    [self settingNavigation];
    [self initMianTableView];
    
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)circleDynamicArray
{
    if (!_circleDynamicArray) {
        _circleDynamicArray = [NSMutableArray array];
    }
    return _circleDynamicArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取“精选圈子动态”数据>
-(void)getBestDynamicDataWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kBestNews];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"page":page,
                                    @"page_count":@10};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                NSError *error = nil;
                MyCircleDynamicDataModel *modelData = [[MyCircleDynamicDataModel alloc]initWithDictionary:dataDict[@"data"] error:&error];
                for (MyCircleDynamicResultModel *modelDynamicResult in modelData.result) {
                    [self.circleDynamicArray addObject:modelDynamicResult];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mainTableView reloadData];
                    [self.mainTableView.mj_footer endRefreshing];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    [self.mainTableView.mj_footer endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                [self.mainTableView.mj_footer endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
            [self.mainTableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark - <关注／取消关注好友>
-(void)attentionOrCancelAttentionWithFriendUserID:(NSString *)friend_user_id attentionType:(NSString *)attention_type
{
    NSString *urlStr = [NSString string];
    if ([attention_type isEqualToString:@"1"]) {
        urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kAttentionFriend];
    }else{
        urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kCancelAttention];
    }
    
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"friend_user_id":friend_user_id};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.circleDynamicArray removeAllObjects];
                    [self getBestDynamicDataWithPage:@1];
                    
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
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
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
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.mainTableView.estimatedRowHeight = 80.0f;
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    
    
    UINib *nibHeaderCell = [UINib nibWithNibName:NSStringFromClass([DiscoverHeaderCell class]) bundle:nil];
    [self.mainTableView registerNib:nibHeaderCell forCellReuseIdentifier:NSStringFromClass([DiscoverHeaderCell class])];
    
    [self.mainTableView registerClass:[DiscoverDynamicCell class] forCellReuseIdentifier:NSStringFromClass([DiscoverDynamicCell class])];
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getBestDynamicDataWithPage:self.page];
    }];
}



#pragma mark - <跳转“热门话题”页面>
-(void)jumpToHotTopicVC
{
    DiscoverHotTopicViewController *hotTopicVC = [[DiscoverHotTopicViewController alloc]init];
    hotTopicVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hotTopicVC animated:YES];
}

#pragma mark - <跳转“活动推荐”页面>
-(void)jumpToActivityRecommendVC
{
    DiscoverRecommendViewController *activityRecommendVC = [[DiscoverRecommendViewController alloc]init];
    activityRecommendVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityRecommendVC animated:YES];
}



#pragma mark - <跳转dynamicDetailVC>
-(void)jumpToDynamicDetailVCWithUserID:(NSString *)user_id talkID:(NSString *)talk_id
{
    DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc]initWithNibName:NSStringFromClass([DynamicDetailViewController class]) bundle:nil];
    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
    dynamicDetailVC.user_id = user_id;
    dynamicDetailVC.talk_id = talk_id;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}
#pragma mark - <跳转mainCircleVC>
-(void)jumpToMainCircleVC
{
    MainCircleViewController *mainCircleVC = [[MainCircleViewController alloc]init];
    mainCircleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mainCircleVC animated:YES];
}
#pragma mark - <跳转sameTownVC>
-(void)jumpToSameTownVC
{
    SameTownViewController *sameTownVC = [[SameTownViewController alloc]initWithNibName:NSStringFromClass([SameTownViewController class]) bundle:nil];
    sameTownVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sameTownVC animated:YES];
}
#pragma mark - <跳转domainVC>
-(void)jumpToDomainVC
{
    DomainViewController *domainVC = [[DomainViewController alloc]initWithNibName:NSStringFromClass([DomainViewController class]) bundle:nil];
    domainVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:domainVC animated:YES];
}

#pragma mark - <跳转“个人好友”资料>
-(void)jumpToFocusPersonalFileVCWithUserID:(NSString *)user_id
{
    FocusPersonFileViewController *focusPersonalFileVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
    focusPersonalFileVC.friend_user_id = user_id;
    focusPersonalFileVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:focusPersonalFileVC animated:YES];
}

#pragma mark - <跳转“话题详情”页面>
-(void)jumpToTopicDetailVCWithTopicID:(NSString *)topic_id
{
    TopicDetailViewController *topicDetailVC = [[TopicDetailViewController alloc]initWithNibName:NSStringFromClass([TopicDetailViewController class]) bundle:nil];
    topicDetailVC.topic_id = topic_id;
    topicDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}

#pragma mark - <响应RAC>
-(void)respondWithRAC
{
    //flipView滑动后segmentView跟着变化
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"Discover_Filp" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSNumber *num = x.object;
        NSInteger index = [num integerValue];
        [self.segmentView selectIndex:index];
        
    }];
    
    //点击圈子
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"clickCircleAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToMainCircleVC];
    }];
    
    //点击同城
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"clickSameTownAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToSameTownVC];
    }];
    
    //点击地盘
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"clickDomainAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToDomainVC];
    }];
    
    //关注好友
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"attentionFriendByDiscover" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *user_id = x.object;
        [self attentionOrCancelAttentionWithFriendUserID:user_id attentionType:@"1"];
    }];
    
    //取消关注好友
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"cancelAttentionFriendByDiscover" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *user_id = x.object;
        [self attentionOrCancelAttentionWithFriendUserID:user_id attentionType:@"0"];
    }];
    
    //动态详情里点击关注后刷新该页面
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"refreshDiscoverVCData" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        [self.circleDynamicArray removeAllObjects];
        [self getBestDynamicDataWithPage:@1];
    }];
    
    //点击"@人"跳转到好友主页
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToFocusPersonalVCByAtSomeoneFromDiscover" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *user_id = x.object;
        [self jumpToFocusPersonalFileVCWithUserID:user_id];
    }];
    
    //点击用户头像跳转到好友主页
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToFocusPersonalVCByPortraitFromDiscover" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *user_id = x.object;
        [self jumpToFocusPersonalFileVCWithUserID:user_id];
    }];
    
    //点击富文本话题跳转话题详情
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToFocusPersonalVCByTopicFromDiscover" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *topic_id = x.object;
        [self jumpToTopicDetailVCWithTopicID:topic_id];
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
//    NSNumber *indexNum = [NSNumber numberWithInteger:index];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"Discover_Segment" object:indexNum];
    
    [self.segmentView selectIndex:1];
    
    if (index == 1) {
        [self jumpToHotTopicVC];
    }else if (index == 2){
        [self jumpToActivityRecommendVC];
    }
}

#pragma mark - ********* UITableViewDelegate,UITableViewDataSource ********
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.circleDynamicArray.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 320;
    }
    DiscoverDynamicCell *cell = [[DiscoverDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DiscoverDynamicCell class])];
    MyCircleDynamicResultModel *modelResult = self.circleDynamicArray[indexPath.row];
    cell.modelCircleDynamicResult = modelResult;
    return cell.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    return 41;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        DiscoverHeaderCell *cell1 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DiscoverHeaderCell class])];
        cell = cell1;
    }else{
        DiscoverDynamicCell *cell2 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DiscoverDynamicCell class])];
        MyCircleDynamicResultModel *modelResult = self.circleDynamicArray[indexPath.row];
        cell2.whereReuseFrom = @"discover";
        cell2.modelCircleDynamicResult = modelResult;
        cell = cell2;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    headerView.backgroundColor = kColorFromRGB(kLightGray);
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
    if (indexPath.section == 1) {
        MyCircleDynamicResultModel *modelResult = self.circleDynamicArray[indexPath.row];
        [self jumpToDynamicDetailVCWithUserID:modelResult.user_id talkID:modelResult.talk_id];
    }
}

@end
