//
//  DomainViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DomainViewController.h"

//cells
#import "FocusPersonCell.h"
#import "NULLTableViewCell.h"

//views
#import "DomainHeaderView.h"

//controllers
#import "NotificationViewController.h"
#import "PersonalFileViewController.h"
#import "MyFocusViewController.h"
#import "ActivityViewController.h"
#import "MyJoinedActivityViewController.h"
#import "PersonalRankActivityViewController.h"
#import "NewPostViewController.h"

//models
#import "FriendHomePageDataModel.h"
#import "FriendHomePageResultModel.h"
#import "FriendHomePageUser_infoModel.h"
#import "MyCircleDynamicDataModel.h"
#import "MyCircleDynamicResultModel.h"
#import "MyCircleDynamicTips_infoModel.h"

@interface DomainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *circleDynamicArray;

@property (nonatomic, strong)FriendHomePageResultModel *modelResult;

@property (nonatomic, strong)NSNumber *page;

@end

@implementation DomainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = @1;
    [self managerRequestWithGCD];
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
    dispatch_queue_t queue1 = dispatch_queue_create("getPersonalHomePageData", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("getMyCircleDynamicData", NULL);
    
    dispatch_group_async(group, queue1, ^{
        [self getPersonalHomePageData];
    });
    dispatch_group_async(group, queue2, ^{
        [self getMyDynamicDataWithPage:@1];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [hud hideAnimated:YES afterDelay:1.0];
    });
}

#pragma mark - <获取个人主页资料>
-(void)getPersonalHomePageData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kFriendHomePage];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"friend_user_id":kUserDefaultObject(kUserInfo)};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                FriendHomePageDataModel *modelData = [[FriendHomePageDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.modelResult = modelData.result;
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

#pragma mark - <获取“我的个人动态”数据>
-(void)getMyDynamicDataWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kPersonalNews];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
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

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[FocusPersonCell class] forCellReuseIdentifier:NSStringFromClass([FocusPersonCell class])];
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getMyDynamicDataWithPage:self.page];
    }];
}

#pragma mark - <跳转“我的关注”页面>
-(void)jumpToMyOnFocusVCWithFansOrFocus:(NSString *)fansOrFocus
{
    MyFocusViewController *myFocusVC = [[MyFocusViewController alloc]initWithNibName:NSStringFromClass([MyFocusViewController class]) bundle:nil];
    myFocusVC.myFansOrMyFocus = fansOrFocus;
    [self.navigationController pushViewController:myFocusVC animated:YES];
}

#pragma mark - <跳转“消息通知”页面>
-(void)jumpToMessageVC
{
    NotificationViewController *notificationVC = [[NotificationViewController alloc]init];
    [self.navigationController pushViewController:notificationVC animated:YES];
}

#pragma mark - <跳转“个人资料”页面>
-(void)jumpToPersonalFileVC
{
    PersonalFileViewController *personalFileVC = [[PersonalFileViewController alloc]init];
    [self.navigationController pushViewController:personalFileVC animated:YES];
}

#pragma mark - <跳转“我的活动”页面>
-(void)jumpToMyActivitiesVC
{
    ActivityViewController *activityVC = [[ActivityViewController alloc]initWithNibName:NSStringFromClass([ActivityViewController class]) bundle:nil];
    [self.navigationController pushViewController:activityVC animated:YES];
}

#pragma mark - <跳转“参与的活动”页面>
-(void)jumpToMyJoinedActivityVC
{
    MyJoinedActivityViewController *myJoinedActivityVC = [[MyJoinedActivityViewController alloc]init];
    [self.navigationController pushViewController:myJoinedActivityVC animated:YES];
}

#pragma mark - <跳转“个人活跃度排名”页面>
-(void)jumpToPersonalRankVC
{
    PersonalRankActivityViewController *personalRankVC = [[PersonalRankActivityViewController alloc]initWithNibName:NSStringFromClass([PersonalRankActivityViewController class]) bundle:nil];
    [self.navigationController pushViewController:personalRankVC animated:YES];
}

#pragma mark - <跳转发布新帖子页面>
-(void)jumpToReleaseNewPostVC
{
    NewPostViewController *newPostVC = [[NewPostViewController alloc]initWithNibName:NSStringFromClass([NewPostViewController class]) bundle:nil];
    newPostVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newPostVC animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"backToDiscover" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToMessage" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToMessageVC];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToEdit" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToPersonalFileVC];
    }];
    
    //查看为关注的人
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToMyFocus" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToMyOnFocusVCWithFansOrFocus:@"focus"];
    }];
    
    //查看我的粉丝
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToMyFans" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToMyOnFocusVCWithFansOrFocus:@"fans"];
    }];
    
    //我的活动
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToMyActivities" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToMyActivitiesVC];
    }];
    
    //我参与的活动
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToJoinedActivities" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToMyJoinedActivityVC];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToRankActivity" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToPersonalRankVC];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToRelease" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToReleaseNewPostVC];
    }];
}










#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 350;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DomainHeaderView *headerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([DomainHeaderView class]) owner:nil options:nil].lastObject;
    headerView.modelResult = self.modelResult;
    return headerView;
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



@end
