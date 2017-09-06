//
//  MyCircleViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyCircleViewController.h"

//cells
#import "MyCircleHeaderCell.h"
#import "FocusPersonCell.h"
#import "JoinedCircleCell.h"
#import "MoreTableViewCell.h"
#import "NULLTableViewCell.h"

//models
#import "MyJoinedCircleDataModel.h"
#import "MyJoinedCircleResultModel.h"
#import "MyCircleDynamicDataModel.h"
#import "MyCircleDynamicResultModel.h"
#import "MyCircleDynamicTips_infoModel.h"

//controllers
#import "MoreCycleViewController.h"
#import "CircleDetailViewController.h"
#import "FocusPersonFileViewController.h"
#import "TopicDetailViewController.h"

@interface MyCircleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *joinedCircleArray;
@property (nonatomic, strong)NSMutableArray *circleDynamicArray;

@property (nonatomic, strong)NSNumber *page;

@end

@implementation MyCircleViewController

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
    dispatch_queue_t queue1 = dispatch_queue_create("getMyJoinedCircleData", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("getMyCircleDynamicData", NULL);
    
    dispatch_group_async(group, queue1, ^{
        [self getMyJoinedCircleData];
    });
    dispatch_group_async(group, queue2, ^{
        [self getMyCircleDynamicDataWithPage:@1];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [hud hideAnimated:YES afterDelay:1.0];
    });
}

#pragma mark - <获取“已加入圈子”数据>
-(void)getMyJoinedCircleData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kMyJoinedCircle];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
    
//    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                MyJoinedCircleDataModel *model = [[MyJoinedCircleDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.joinedCircleArray = model.result;
                
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

#pragma mark - <获取“我的圈子-圈子动态”数据>
-(void)getMyCircleDynamicDataWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kCircleNews];
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

#pragma mark - <点赞／取消点赞>
-(void)requestLikeOrCancelLikeWithTalkID:(NSString *)talk_id likeType:(NSString *)like_type
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kLikeCancel];
    
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"talk_id":talk_id,
                                    @"is_cancel":like_type};
    
    
    //    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
    //                                    @"friend_user_id":friend_user_id};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.circleDynamicArray removeAllObjects];
                    [self getMyCircleDynamicDataWithPage:@1];
                    
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

#pragma mark - <跳转更多圈子页面>
-(void)jumpToMoreCircleVCWithMoreType:(NSString *)moreType classifyID:(NSString *)classify_id
{
    MoreCycleViewController *moreCircleVC = [[MoreCycleViewController alloc]initWithNibName:NSStringFromClass([MoreCycleViewController class]) bundle:nil];
    moreCircleVC.moreType = moreType;
    moreCircleVC.classify_id = classify_id;
    moreCircleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreCircleVC animated:YES];
}

#pragma mark - <跳转“圈子详情”页面>
-(void)jumpToCircleDetailVCWithCircleID:(NSString *)circle_id
{
    CircleDetailViewController *circleDetailVC = [[CircleDetailViewController alloc]initWithNibName:NSStringFromClass([CircleDetailViewController class]) bundle:nil];
    circleDetailVC.circle_id = circle_id;
    circleDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:circleDetailVC animated:YES];
}

#pragma mark - <跳转“好友详情”页面>
-(void)jumpToFocusPersonalVCWithUserID:(NSString *)user_id
{
    FocusPersonFileViewController *focusPersonalVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
    focusPersonalVC.friend_user_id = user_id;
    [self.navigationController pushViewController:focusPersonalVC animated:YES];
}

#pragma mark - <跳转“话题详情”页面>
-(void)jumpToTopicDetailVCWithTopicID:(NSString *)topic_id
{
    TopicDetailViewController *topicDetailVC = [[TopicDetailViewController alloc]initWithNibName:NSStringFromClass([TopicDetailViewController class]) bundle:nil];
    topicDetailVC.topic_id = topic_id;
    topicDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibHeader = [UINib nibWithNibName:NSStringFromClass([MyCircleHeaderCell class]) bundle:nil];
    [self.tableView registerNib:nibHeader forCellReuseIdentifier:NSStringFromClass([MyCircleHeaderCell class])];
    
    [self.tableView registerClass:[FocusPersonCell class] forCellReuseIdentifier:NSStringFromClass([FocusPersonCell class])];
    
    UINib *nibJoinCircle = [UINib nibWithNibName:NSStringFromClass([JoinedCircleCell class]) bundle:nil];
    [self.tableView registerNib:nibJoinCircle forCellReuseIdentifier:NSStringFromClass([JoinedCircleCell class])];
    
    UINib *nibMore = [UINib nibWithNibName:NSStringFromClass([MoreTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibMore forCellReuseIdentifier:NSStringFromClass([MoreTableViewCell class])];
    
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
    //点击“@人”跳转好友主页
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToFocusPersonalVCByAtSomeoneFromMyCircleVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *user_id = x.object;
        [self jumpToFocusPersonalVCWithUserID:user_id];
    }];
    
    //点击头像跳转好友主页
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToFocusPersonalVCByPortraitFromMyCircleVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *user_id = x.object;
        [self jumpToFocusPersonalVCWithUserID:user_id];
    }];
    
    //点击富文本话题跳转话题详情
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToFocusPersonalVCByTopicFromMyCircleVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *topic_id = x.object;
        [self jumpToTopicDetailVCWithTopicID:topic_id];
    }];
    
    //点赞
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"likeByClickFromMyCircleVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *talk_id = x.object;
        [self requestLikeOrCancelLikeWithTalkID:talk_id likeType:@"0"];
    }];
    
    //取消点赞
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"cancelLikeByClickFromMyCircleVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *talk_id = x.object;
        [self requestLikeOrCancelLikeWithTalkID:talk_id likeType:@"1"];
    }];
}

















#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.joinedCircleArray.count > 3) {
            return 5;
        }
        return self.joinedCircleArray.count+1;
    }else{
        if (self.circleDynamicArray.count == 0) {
            return 1;
        }
        return self.circleDynamicArray.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 150;
        }else if (indexPath.row == 4){
            return 40;
        }
        return 70;
    }else{
        if (self.circleDynamicArray.count == 0) {
            return 500;
        }
        MyCircleDynamicResultModel *modelResult = self.circleDynamicArray[indexPath.row];
        FocusPersonCell *cellDynamic = [[FocusPersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FocusPersonCell class])];
        cellDynamic.modelCircleDynamicResult = modelResult;
        return cellDynamic.cellHeight;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MyCircleHeaderCell * cellHeader = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyCircleHeaderCell class])];
            cell = cellHeader;
        }else if (indexPath.row == 4){
            MoreTableViewCell *cellMore = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MoreTableViewCell class])];
            cell = cellMore;
        }else{
            JoinedCircleCell *cellJoined = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JoinedCircleCell class])];
            MyJoinedCircleResultModel *modelResult = self.joinedCircleArray[indexPath.row-1];
            cellJoined.modelJoinedCircle = modelResult;
            cell = cellJoined;
        }
        
    }else{
        if (self.circleDynamicArray.count == 0) {
            NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
            cell = cellNull;
        }else{
            FocusPersonCell *cellFocusDynamic = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FocusPersonCell class])];
            MyCircleDynamicResultModel *modelResult = self.circleDynamicArray[indexPath.row];
            cellFocusDynamic.modelCircleDynamicResult = modelResult;
            cellFocusDynamic.whereFrom = @"myCircleVC";
            cell = cellFocusDynamic;
        }
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = kColorFromRGB(kWhite);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
        label.text = @"关注圈子动态";
        label.font = [UIFont systemFontOfSize:12];
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {
            [self jumpToMoreCircleVCWithMoreType:@"moreJoined" classifyID:nil];
        }else if (indexPath.row == 0){
            
        }else{
            MyJoinedCircleResultModel *modelResult = self.joinedCircleArray[indexPath.row-1];
            [self jumpToCircleDetailVCWithCircleID:modelResult.circle_id];
        }
    }else{
        if (self.circleDynamicArray.count > 0) {
            
        }
    }
}


@end
