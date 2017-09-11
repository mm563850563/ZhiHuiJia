//
//  HomePageViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/5.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "HomePageViewController.h"

//views
#import "HomePageRecommendHeaderView.h"
#import "HomePageSameHobbyHeaderView.h"

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
#import "RecommendGoodsCell.h"//为您推荐cell
#import "HomeLeftImageCell.h"
#import "HomeRightImageCell.h"
#import "IntellectWearsCell.h"//智能穿戴大的tableViewCell
#import "SameHobbyCell.h"//发现同趣的人的大cell
#import "MoreNewProductCell.h"

//models
#import "HomeGoodsModel.h"
#import "HomeGoodsResultModel.h"
#import "HomeGoodsListModel.h"
#import "IndexCarouselModel.h"
#import "IndexCarouselResultModel.h"
#import "GetGiftTypeModel.h"
#import "GetGiftTypeResultModel.h"
#import "RecommendGoodsModel.h"

#import "GetSimilarUserDataModel.h"
#import "GetSimilarUserResultModel.h"

@interface HomePageViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,CycleScrollViewCellDelegate,UISearchBarDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)UISearchBar *searchBarHomePage;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSArray *carouselResultArray;
@property (nonatomic, strong)NSArray *homeGoodsResultArray;
@property (nonatomic, strong)NSArray *homeGoodsListArray;
//@property (nonatomic, strong)NSArray *recommendResultArray;
@property (nonatomic, strong)NSArray *similarUserArray;
@property (nonatomic, strong)GetGiftTypeResultModel *getGiftResultModel;

@property (nonatomic, strong)UIImageView *imgViewPortrait;

@property (nonatomic, strong)RecommendGoodsDataModel *modelRecommendData;

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
    dispatch_queue_t queue3 = dispatch_queue_create("getGiftType", NULL);
    dispatch_queue_t queue4 = dispatch_queue_create("getRecommendGoods", NULL);
    dispatch_queue_t queue5 = dispatch_queue_create("getSimilarUser", NULL);
    
    dispatch_group_async(group, queue1, ^{
        [self getIndexCarouselData];
    });
    dispatch_group_async(group, queue2, ^{
        [self getHomeGoodsData];
    });
    dispatch_group_async(group, queue3, ^{
        if (kUserDefaultObject(kUserInfo)) {
            [self getGiftTypeData];
        }
    });
    dispatch_group_async(group, queue4, ^{
        [self getRecommendGoodsData];
    });
    dispatch_group_async(group, queue5, ^{
        [self getSimilarUserData];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [hud hideAnimated:YES afterDelay:1.0];
    });
}

#pragma mark - <下拉刷新请求>
-(void)pullDownRefresh
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue1 = dispatch_queue_create("getIndexCarousel", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("getHomeGoods", NULL);
    dispatch_queue_t queue3 = dispatch_queue_create("getGiftType", NULL);
    dispatch_queue_t queue4 = dispatch_queue_create("getRecommendGoods", NULL);
    dispatch_queue_t queue5 = dispatch_queue_create("getSimilarUser", NULL);
    
    dispatch_group_async(group, queue1, ^{
        [self getIndexCarouselData];
    });
    dispatch_group_async(group, queue2, ^{
        [self getHomeGoodsData];
    });
    dispatch_group_async(group, queue3, ^{
        if (kUserDefaultObject(kUserInfo)) {
            [self getGiftTypeData];
        }
        
    });
    dispatch_group_async(group, queue4, ^{
        [self getRecommendGoodsData];
    });
    dispatch_group_async(group, queue5, ^{
        [self getSimilarUserData];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    });
}

#pragma mark - <获取轮播图数据>
-(void)getIndexCarouselData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kIndexCarousel];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:YES params:nil progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            IndexCarouselModel *model = [[IndexCarouselModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToNumber:[NSNumber numberWithInteger:200]]) {
                self.carouselResultArray = model.data.result;
                //回到主线程刷新数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        }
    } failBlock:^(NSError *error) {
        if (error.code == -1009) {
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:@"请检查网络"];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }
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
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:kRequestError];
        [hudWarning hideAnimated:YES afterDelay:2.0];
        
    }];
}

#pragma  mark - <获取拿好礼类型>
-(void)getGiftTypeData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetGiftType];
    
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:YES params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            GetGiftTypeModel *model = [[GetGiftTypeModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                self.getGiftResultModel = model.data.result;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    //设置头像
                    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,self.getGiftResultModel.headimg];
                    NSURL *url = [NSURL URLWithString:imgStr];
                    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
                });
            }else{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        }
    } failBlock:^(NSError *error) {
        if (error.code == -1009) {
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:@"请检查网络"];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }
    }];
}

#pragma mark - <获取“为你推荐”数据>
-(void)getRecommendGoodsData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetRecommendGoods];
    
    if (kUserDefaultObject(kUserInfo)) {
        NSString *userID = kUserDefaultObject(kUserInfo);
        NSDictionary *dictParameter = @{@"user_id":userID};
        
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:YES params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                RecommendGoodsModel *model = [[RecommendGoodsModel alloc]initWithDictionary:dataDict error:nil];
                if ([model.code isEqualToString:@"200"]) {
                    self.modelRecommendData = model.data;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }else{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                }
            }
        } failBlock:^(NSError *error) {
            if (error.code == -1009) {
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.navigationController.view animated:YES warningMessage:@"请检查网络"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        }];
    }
    
}

#pragma mark - <获取“同趣的人”数据>
-(void)getSimilarUserData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetSimilarUser];
    
    if (kUserDefaultObject(kUserInfo)) {
        NSString *userID = kUserDefaultObject(kUserInfo);
        NSDictionary *dictParameter = @{@"user_id":userID};
        
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:YES params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                NSNumber *code = (NSNumber *)dataDict[@"code"];
                
                if ([code isEqual:@200]) {
                    GetSimilarUserDataModel *modelData = [[GetSimilarUserDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                    self.similarUserArray = modelData.result;
                    
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
    UINib *nibMoreNew = [UINib nibWithNibName:NSStringFromClass([MoreNewProductCell class]) bundle:nil];
    [self.tableView registerNib:nibMoreNew forCellReuseIdentifier:NSStringFromClass([MoreNewProductCell class])];
    
    [self.tableView registerClass:[CycleScrollViewCell class] forCellReuseIdentifier:NSStringFromClass([IndexCarouselModel class])];
    
    UINib *nibGiftSending = [UINib nibWithNibName:NSStringFromClass([GiftSendingTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibGiftSending forCellReuseIdentifier:NSStringFromClass([GiftSendingTableViewCell class])];
    
    UINib *nibHomeMain = [UINib nibWithNibName:NSStringFromClass([HomePageMainCell class]) bundle:nil];
    [self.tableView registerNib:nibHomeMain forCellReuseIdentifier:NSStringFromClass([HomePageMainCell class])];
    
    [self.tableView registerClass:[YouthColorCell class] forCellReuseIdentifier:NSStringFromClass([YouthColorCell class])];
    
    [self.tableView registerClass:[RecommendGoodsCell class] forCellReuseIdentifier:NSStringFromClass([RecommendGoodsCell class])];
    
    UINib *nibLeftImage = [UINib nibWithNibName:NSStringFromClass([HomeLeftImageCell class]) bundle:nil];
    [self.tableView registerNib:nibLeftImage forCellReuseIdentifier:NSStringFromClass([HomeLeftImageCell class])];
    
    UINib *nibRightImage = [UINib nibWithNibName:NSStringFromClass([HomeRightImageCell class]) bundle:nil];
    [self.tableView registerNib:nibRightImage forCellReuseIdentifier:NSStringFromClass([HomeRightImageCell class])];
    
    [self.tableView registerClass:[IntellectWearsCell class] forCellReuseIdentifier:NSStringFromClass([IntellectWearsCell class])];
    
    [self.tableView registerClass:[SameHobbyCell class] forCellReuseIdentifier:NSStringFromClass([SameHobbyCell class])];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pullDownRefresh];
    }];
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
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.cornerRadius = 15;
    imgView.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 50, 10)];
    label.text = @"因你而不同";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:9];
    [BGView addSubview:label];
    
    BGView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToPersonalFileVC)];
    [BGView addGestureRecognizer:tap];
    
    self.imgViewPortrait = imgView;
    
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
-(void)jumpToProductDetailVCWithGoodsID:(NSString *)goods_id
{
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:NSStringFromClass([ProductDetailViewController class]) bundle:nil];
    productDetailVC.hidesBottomBarWhenPushed = YES;
    productDetailVC.goods_id = goods_id;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}
#pragma mark - <跳转更多产品页面>
-(void)jumpToMoreProductListVCWithCategoryID:(NSString *)category_id
{
    MoreProductListViewController *moreProductListVC = [[MoreProductListViewController alloc]init];
    moreProductListVC.hidesBottomBarWhenPushed = YES;
    moreProductListVC.category_id = category_id;
    moreProductListVC.is_root = @"yes";
    [self.navigationController pushViewController:moreProductListVC animated:YES];
}
#pragma mark - <跳转“好友主页”页面>
-(void)jumpToFocusPersonFileVCWithFriendUserID:(NSString *)friend_user_id
{
    FocusPersonFileViewController *focusPersonFileVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
    focusPersonFileVC.whereReuseFrom = @"homePageVC";
    focusPersonFileVC.friend_user_id = friend_user_id;
    focusPersonFileVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:focusPersonFileVC animated:YES];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //点击同趣的人
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"SameHobbyCell"object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *friend_user_id = x.object;
        [self jumpToFocusPersonFileVCWithFriendUserID:friend_user_id];
    }];
    
    //点击”拿好礼“按钮
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"RegisterGiftAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *type_id = x.object;
        GetGiftViewController *getGiftVC = [[GetGiftViewController alloc]initWithNibName:NSStringFromClass([GetGiftViewController class]) bundle:nil];
        getGiftVC.hidesBottomBarWhenPushed = YES;
        getGiftVC.type_id = type_id;
        [self.navigationController pushViewController:getGiftVC animated:YES];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"ShareGiftAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *type_id = x.object;
        GetGiftViewController *getGiftVC = [[GetGiftViewController alloc]initWithNibName:NSStringFromClass([GetGiftViewController class]) bundle:nil];
        getGiftVC.hidesBottomBarWhenPushed = YES;
        getGiftVC.type_id = type_id;
        [self.navigationController pushViewController:getGiftVC animated:YES];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"BuyGiftAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *type_id = x.object;
        GetGiftViewController *getGiftVC = [[GetGiftViewController alloc]initWithNibName:NSStringFromClass([GetGiftViewController class]) bundle:nil];
        getGiftVC.hidesBottomBarWhenPushed = YES;
        getGiftVC.type_id = type_id;
        [self.navigationController pushViewController:getGiftVC animated:YES];
    }];
    
    //点击YouthColorCell中的item
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectYouthItem" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *goods_id = x.object;
        [self jumpToProductDetailVCWithGoodsID:goods_id];
    }];
    
    //点击IntellectWearsCell中的上下布局item
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectItemOneSide" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *goods_id = x.object;
        [self jumpToProductDetailVCWithGoodsID:goods_id];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectItemTwoSide" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *goods_id = x.object;
        [self jumpToProductDetailVCWithGoodsID:goods_id];
    }];
    
    //点击IntellectWearsCell中的其他item
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectIntellectWearOverTwoItem" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *goods_id = x.object;
        [self jumpToProductDetailVCWithGoodsID:goods_id];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectIntellectWearNormalItem" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *goods_id = x.object;
        [self jumpToProductDetailVCWithGoodsID:goods_id];
    }];
    
    //在“好友主页”中点击关注／取消关注后刷新主页
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"refreshHomePageVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        [self pullDownRefresh];
    }];
    
    //登陆后刷新该页面
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"refreshHomePageAfterLogin" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        [self managerRequestWithGCD];
    }];
}












#pragma mark - ******** UITableViewDataSource,UITableViewDelegate ********
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.homeGoodsResultArray.count + 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 3;
    
    if (section == 0) {
        return 2;
    }
    else if (section == self.homeGoodsResultArray.count+1){
        return 1;
    }else if (section == self.homeGoodsResultArray.count+2){
        return 2;
    }else{
        HomeGoodsResultModel *model = self.homeGoodsResultArray[section-1];
        NSString *modelID = model.id;
        if ([modelID isEqualToString:@"1"] || [modelID isEqualToString:@"4"] || [modelID isEqualToString:@"8"]) {
            rowCount = model.goods_list.count+2;
        }
    }
    return rowCount;
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
            giftCell.model = self.getGiftResultModel;
            cell = giftCell;
        }
    }else if (indexPath.section == self.homeGoodsResultArray.count+1){//为你精心推荐
        RecommendGoodsCell *cellRecommend = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecommendGoodsCell class])];
        cellRecommend.modelRecommendData = self.modelRecommendData;
        cell = cellRecommend;
    }else if (indexPath.section == self.homeGoodsResultArray.count+2){//发现同趣的人
        if (indexPath.row == 0) {
            SameHobbyCell *cellSameHobby = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SameHobbyCell class])];
            cellSameHobby.similarArray = self.similarUserArray;
            cell = cellSameHobby;
        }else{
            MoreNewProductCell *cellMore = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MoreNewProductCell class])];
            cellMore.labelTitle.text = @"更多同趣的人>";
            cell = cellMore;
        }
        
    }else{
        HomeGoodsResultModel *modelResult = self.homeGoodsResultArray[indexPath.section-1];
        if (indexPath.row == 0){
            HomePageMainCell *cellHomeMain = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageMainCell class])];
            cellHomeMain.imgString = modelResult.big_img.image;
            cell = cellHomeMain;
        }else{
            if ([modelResult.id isEqualToString:@"3"] || [modelResult.id isEqualToString:@"6"]) {
                if (indexPath.row == 1) {
                    IntellectWearsCell *cellIntellect = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IntellectWearsCell class])];
                    
                    cellIntellect.model = modelResult;
                    
                    cell = cellIntellect;
                }
                if (indexPath.row == 2) {
                    MoreNewProductCell *cellMore = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MoreNewProductCell class])];
                    cellMore.labelTitle.text = @"更多新品>";
                    cell = cellMore;
                }
            }else if ([modelResult.id isEqualToString:@"1"] || [modelResult.id isEqualToString:@"4"] || [modelResult.id isEqualToString:@"8"]){
                if (indexPath.row == modelResult.goods_list.count+1) {
                    MoreNewProductCell *cellMore = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MoreNewProductCell class])];
                    cellMore.labelTitle.text = @"更多新品>";
                    cell = cellMore;
                }else{
                    if (indexPath.row % 2 == 0) {
                        HomeRightImageCell *cellRight = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeRightImageCell class])];
                        HomeGoodsListModel *model = modelResult.goods_list[indexPath.row-1];
                        cellRight.model = model;
                        cell = cellRight;
                    }else{
                        HomeLeftImageCell *cellLeft = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeLeftImageCell class])];
                        HomeGoodsListModel *model = modelResult.goods_list[indexPath.row-1];
                        cellLeft.model = model;
                        cell = cellLeft;
                    }
                }
            }else{
                if (indexPath.row == 2) {
                    MoreNewProductCell *cellMore = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MoreNewProductCell class])];
                    cellMore.labelTitle.text = @"更多新品>";
                    cell = cellMore;
                }
                if (indexPath.row == 1) {
                    YouthColorCell *cellYouth = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YouthColorCell class])];
                    cellYouth.model = modelResult;
                    cell = cellYouth;
                }
            }
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = kSCREEN_WIDTH/5.2*3.0;
    if (indexPath.section == 0) {
        height = kSCREEN_WIDTH/5.2*3.5;
    }else if (indexPath.section == self.homeGoodsResultArray.count+1){
        RecommendGoodsCell *cellRecommendGoods = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecommendGoodsCell class])];
        cellRecommendGoods.modelRecommendData = self.modelRecommendData;
        height = cellRecommendGoods.cellHeight;
    }else if (indexPath.section == self.homeGoodsResultArray.count+2){
        if (indexPath.row == 0) {
            SameHobbyCell *cellSameHobby = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SameHobbyCell class])];
            cellSameHobby.similarArray = self.similarUserArray;
            return cellSameHobby.cellHeight;
        }else if (indexPath.row == 1){
            return 40;
        }
    }else{
        if (indexPath.row == 0){
            height = kSCREEN_WIDTH/5.2*3.0;
        }else{
            HomeGoodsResultModel *modelResult = self.homeGoodsResultArray[indexPath.section-1];
            if ([modelResult.id isEqualToString:@"3"] || [modelResult.id isEqualToString:@"6"]) {
                if (indexPath.row == 1) {
                    IntellectWearsCell *cellIntellect = [[IntellectWearsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([IntellectWearsCell class])];
                    
                    cellIntellect.model = modelResult;
                    return cellIntellect.cellHeight;
                }
                if (indexPath.row == 2) {
                    height = 40;
                }
            }else if ([modelResult.id isEqualToString:@"1"] || [modelResult.id isEqualToString:@"4"] || [modelResult.id isEqualToString:@"8"]){
                if (indexPath.row == modelResult.goods_list.count+1) {
                    height = 40;
                }else{
                    height = kSCREEN_WIDTH/2.0;
                }
                
            }else{
                if (indexPath.row == 1) {
                    HomeGoodsResultModel *modelResult = self.homeGoodsResultArray[indexPath.section-1];
                    YouthColorCell *cell = [[YouthColorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([YouthColorCell class])];
                    cell.model = modelResult;
                    height = cell.cellHeight;
                }else if (indexPath.row == 2){
                    height = 40;
                }
                
            }
        }
    }
    
    
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > self.homeGoodsResultArray.count) {
        return 70;
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
    
    UIView *headerView = [[UIView alloc]init];
    
    if (section == self.homeGoodsResultArray.count + 1) {
        HomePageRecommendHeaderView *headerRecommendView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HomePageRecommendHeaderView class]) owner:nil options:nil].lastObject;
        headerView = headerRecommendView;
    }
    if (section == self.homeGoodsResultArray.count + 2) {
        HomePageSameHobbyHeaderView *headerSameHobbyView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HomePageSameHobbyHeaderView class]) owner:nil options:nil].lastObject;
        headerView = headerSameHobbyView;
    }
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            [self jumpToProductDetailVC];
        }
    }else if (indexPath.section == self.homeGoodsResultArray.count + 1){
        return;
    }else if (indexPath.section == self.homeGoodsResultArray.count + 2){
        if (indexPath.row == 1) {
            //更多同趣的人
            SameHobbyPersonListViewController *sameHobbyPersonListVC = [[SameHobbyPersonListViewController alloc]initWithNibName:NSStringFromClass([SameHobbyPersonListViewController class]) bundle:nil];
            sameHobbyPersonListVC.hidesBottomBarWhenPushed = YES;
            sameHobbyPersonListVC.navigationItem.title = @"与您同趣的人";
            [self.navigationController pushViewController:sameHobbyPersonListVC animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
            HomeGoodsResultModel *modelResult = self.homeGoodsResultArray[indexPath.section-1];
            NSString *goodsID = modelResult.big_img.goods_id;
            [self jumpToProductDetailVCWithGoodsID:goodsID];
        }else{
            HomeGoodsResultModel *modelResult = self.homeGoodsResultArray[indexPath.section-1];
            if ([modelResult.id isEqualToString:@"3"] || [modelResult.id isEqualToString:@"6"]) {
                if (indexPath.row == 2) {
                    //更多新品
                    [self jumpToMoreProductListVCWithCategoryID:modelResult.id];
                }
            }else if ([modelResult.id isEqualToString:@"1"] || [modelResult.id isEqualToString:@"4"] || [modelResult.id isEqualToString:@"8"]){
                
                if (indexPath.row == modelResult.goods_list.count+1) {
                    //更多新品
                    [self jumpToMoreProductListVCWithCategoryID:modelResult.id];
                }else{
                    HomeGoodsListModel *modelGoodsList = modelResult.goods_list[indexPath.row-1];
                    NSString *goodsID = modelGoodsList.goods_id;
                    [self jumpToProductDetailVCWithGoodsID:goodsID];
                }
            }else{
                if (indexPath.row == 2){
                    //更多新品
                    [self jumpToMoreProductListVCWithCategoryID:modelResult.id];
                }
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
    
//    //设置返回键
//    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnBack.frame = CGRectMake(0, 0, 30, 30);
//    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
//    navigationController.navigationItem.leftBarButtonItem = buttonItem;
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
    IndexCarouselResultModel *modelIndexCarouselModel = self.carouselResultArray[index];
    [self jumpToProductDetailVCWithGoodsID:modelIndexCarouselModel.ad_link];
}

#pragma mark - **** UISearchBarDelegate ****
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSArray *array = [NSArray arrayWithObjects:@"sfdgfhjg",@"jtyhrtgr",@"sfdgf",@"sdfdgf", nil];
    
    PYSearchViewController *searchVC = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"请输入关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        MoreProductListViewController *moreProductListVC = [[MoreProductListViewController alloc]init];
        moreProductListVC.whereReuseFrom = @"searchGoods";
        moreProductListVC.keyword = searchText;
        [searchViewController.navigationController pushViewController:moreProductListVC animated:YES];
    }];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}




@end
