//
//  CircleDetailViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/28.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CircleDetailViewController.h"

//views
#import "CircleDetailHeaderView.h"

//cells
#import "FocusPersonCell.h"
#import "NULLTableViewCell.h"
//#import "CircleDetailDynamicCell.h"

//models
#import "CircleDetailDataModel.h"
#import "CircleDetailResultModel.h"
#import "MyCircleDynamicDataModel.h"
#import "MyCircleDynamicResultModel.h"
#import "MyCircleDynamicTips_infoModel.h"

//controllers
#import "NewPostViewController.h"
#import "CircleDetailConfigViewController.h"
#import "CircleSigninListViewController.h"
#import "FocusPersonFileViewController.h"

@interface CircleDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UIView *NewPostView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *circleDynamicArray;

@property (nonatomic, strong)CircleDetailResultModel *modelResult;

@property (nonatomic, strong)NSNumber *page;

@end

@implementation CircleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = @1;
    [self managerRequestWithGCD];
    [self initNewPostView];
    [self settingTableView];
    
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

#pragma mark - <GCD管理多线程>
-(void)managerRequestWithGCD
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue1 = dispatch_queue_create("getCircleDetailData", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("getMyCircleDynamicData", NULL);
    
    dispatch_group_async(group, queue1, ^{
        [self getCircleDetailData];
    });
    dispatch_group_async(group, queue2, ^{
        [self getMyCircleDynamicDataWithPage:@1];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [hud hideAnimated:YES afterDelay:1.0];
    });
}

#pragma mark - <获取“圈子详情”数据>
-(void)getCircleDetailData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kCircleDetail];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"circle_id":self.circle_id};
    
//    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                CircleDetailDataModel *modelData = [[CircleDetailDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.modelResult = modelData.result;
                
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
}

#pragma mark - <获取“圈子详情-圈子动态”数据>
-(void)getMyCircleDynamicDataWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetCirclePost];
    NSDictionary *dictParameter = @{@"circle_id":self.circle_id,
                                    @"page":page,
                                    @"page_count":@10};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                MyCircleDynamicDataModel *modelData = [[MyCircleDynamicDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                for (MyCircleDynamicResultModel *modelDynamicResult in modelData.result) {
                    [self.circleDynamicArray addObject:modelDynamicResult];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    [self.tableView.mj_footer endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                [self.tableView.mj_footer endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark - <加入圈子请求>
-(void)requestJoinCircleWithCircleID:(NSString *)circle_id
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kJoinCircle];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"circle_id":circle_id};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    hud.completionBlock = ^{
                        [self getCircleDetailData];
                    };
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

#pragma mark - <签到圈子请求>
-(void)requestSigninCircleWithCircleID:(NSString *)circle_id
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kSignInCircle];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"circle_id":circle_id};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    hud.completionBlock = ^{
                        [self getCircleDetailData];
                    };
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



#pragma mark - <初始化“发帖”按钮>
-(void)initNewPostView
{
    self.NewPostView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.view addSubview:self.NewPostView];
    [self.NewPostView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-40);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    self.NewPostView.backgroundColor = kColorFromRGB(kThemeYellow);
    self.NewPostView.layer.cornerRadius = 30;
    self.NewPostView.layer.masksToBounds = YES;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.NewPostView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.size.mas_offset(CGSizeMake(30, 30));
        make.centerX.mas_equalTo(0);
    }];
    imgView.image = [UIImage imageNamed:@"pen"];
    imgView.layer.cornerRadius = 15;
    imgView.layer.masksToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.NewPostView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(imgView.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    label.text = @"发帖";
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = kColorFromRGB(kDeepGray);
    label.textAlignment = NSTextAlignmentCenter;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.NewPostView.bounds;
    [self.NewPostView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [button addTarget:self action:@selector(jumpToReleaseNewPostVC) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - <跳转发布新帖子页面>
-(void)jumpToReleaseNewPostVC
{
    NewPostViewController *newPostVC = [[NewPostViewController alloc]initWithNibName:NSStringFromClass([NewPostViewController class]) bundle:nil];
    newPostVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newPostVC animated:YES];
}

#pragma mark - <跳转“圈子详情设置”页面>
-(void)jumpToCircleDetailConfigVCWithCircleID:(NSString *)circle_id
{
    CircleDetailConfigViewController *circleDetailConfigVC = [[CircleDetailConfigViewController alloc]initWithNibName:NSStringFromClass([CircleDetailConfigViewController class]) bundle:nil];
    circleDetailConfigVC.circle_id = circle_id;
    [self.navigationController pushViewController:circleDetailConfigVC animated:YES];
}

#pragma mark - <跳转“查看签到列表”页面>
-(void)jumpToCheckSigninListVCWithCircleID:(NSString *)circle_id
{
    CircleSigninListViewController *signinListVC = [[CircleSigninListViewController alloc]initWithNibName:NSStringFromClass([CircleSigninListViewController class]) bundle:nil];
    signinListVC.circle_id = circle_id;
    [self.navigationController pushViewController:signinListVC animated:YES];
}

#pragma mark - <跳转“好友详情”页面>
-(void)jumpToFocusPersonalVCWithUserID:(NSString *)user_id
{
    FocusPersonFileViewController *focusPersonalVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
    focusPersonalVC.friend_user_id = user_id;
    [self.navigationController pushViewController:focusPersonalVC animated:YES];
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    
    [self.tableView registerClass:[FocusPersonCell class] forCellReuseIdentifier:NSStringFromClass([FocusPersonCell class])];
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getMyCircleDynamicDataWithPage:self.page];
    }];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //跳转圈子详情设置页面
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToCircleConfigureVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToCircleDetailConfigVCWithCircleID:self.modelResult.circle_id];
    }];
    
    //点击“关注圈子”
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"joinCircleFromCircleDetail" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *circle_id = x.object;
        [self requestJoinCircleWithCircleID:circle_id];
    }];
    
    //点击“签到”
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"signinCircleFromCircleDetail" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *circle_id = x.object;
        [self requestSigninCircleWithCircleID:circle_id];
    }];
    
    //查看签到列表
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"checkSigninListFromCircleDetail" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *circle_id = x.object;
        [self jumpToCheckSigninListVCWithCircleID:circle_id];
    }];
    
    //退出圈子后重新刷新数据
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"exitCircleRefresh" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        [self getCircleDetailData];
    }];
    
    //好友主页
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToFocusPersonalVCFromAtSomeone" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
            NSString *user_id = x.object;
            [self jumpToFocusPersonalVCWithUserID:user_id];
    }];

}













#pragma mark - ***** UITableViewDelegate,UITableViewDataSource *****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.circleDynamicArray.count == 0) {
        return 1;
    }
    return self.circleDynamicArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.circleDynamicArray.count == 0) {
        return 500;
    }
    MyCircleDynamicResultModel *modelResult = self.circleDynamicArray[indexPath.row];
    FocusPersonCell *cellDynamic = [[FocusPersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FocusPersonCell class])];
    cellDynamic.modelCircleDynamicResult = modelResult;
    return cellDynamic.cellHeight;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (self.circleDynamicArray.count == 0) {
        NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        cell = cellNull;
    }else{
        FocusPersonCell *cellFocusDynamic = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FocusPersonCell class])];
        MyCircleDynamicResultModel *modelResult = self.circleDynamicArray[indexPath.row];
        cellFocusDynamic.modelCircleDynamicResult = modelResult;
        cell = cellFocusDynamic;
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CircleDetailHeaderView *headerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CircleDetailHeaderView class]) owner:nil options:nil].lastObject;
    NSArray *signinMenberArray = self.modelResult.signin_members;
    headerView.signinMembersArray = signinMenberArray;
    headerView.modelCircleDetailResult = self.modelResult;
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSCREEN_WIDTH+80;
}



@end
