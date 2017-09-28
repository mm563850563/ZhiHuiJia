//
//  TopicDetailViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/2.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "TopicDetailViewController.h"

//cells
#import "TopicDetailHeaderCell.h"
#import "FocusPersonCell.h"

//models
#import "TopicDetailDataModel.h"
#import "TopicDetailResultModel.h"
#import "MyCircleDynamicDataModel.h"
#import "MyCircleDynamicResultModel.h"
#import "MyCircleDynamicTips_infoModel.h"


#import "FocusPersonFileViewController.h"

@interface TopicDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)TopicDetailResultModel *modelTopicDetailResult;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *topicCommentArray;


@property (nonatomic, strong)NSNumber *page;

@end

@implementation TopicDetailViewController

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
-(NSMutableArray *)topicCommentArray
{
    if (!_topicCommentArray) {
        _topicCommentArray = [NSMutableArray array];
    }
    return _topicCommentArray;
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
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_queue_t queue1 = dispatch_queue_create("getTopicDetailData", NULL);
//    dispatch_queue_t queue2 = dispatch_queue_create("getTopicCommemtListData", NULL);
    
    dispatch_group_async(group, queue, ^{
        [self getTopicDetailData];
    });
    dispatch_group_async(group, queue, ^{
        [self getTopicCommemtListDataWithPage:@1];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [hud hideAnimated:YES afterDelay:1.0];
    });
}

#pragma mark - <话题详情头部数据>
-(void)getTopicDetailData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kTopicDetail];
    NSDictionary *dictParameter = @{@"topic_id":self.topic_id};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                TopicDetailDataModel *modelData = [[TopicDetailDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.modelTopicDetailResult = modelData.result;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <获取“话题评论列表”数据>
-(void)getTopicCommemtListDataWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetTopicReview];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"topic_id":self.topic_id,
                                    @"page":page,
                                    @"page_count":@10};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                MyCircleDynamicDataModel *modelData = [[MyCircleDynamicDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                for (MyCircleDynamicResultModel *modelDynamicResult in modelData.result) {
                    [self.topicCommentArray addObject:modelDynamicResult];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    [self.tableView.mj_footer endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
                [self.tableView.mj_footer endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark - <返回按钮响应>
- (IBAction)btnBackAction:(UIButton *)sender
{
//    //在当前当前控件遍历所在的viewcontroller
//    for (UIView* next = [self superview]; next; next = next.superview) {
//        UIResponder* nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            UIViewController *vc = (UIViewController *)nextResponder;
//            [vc.navigationController popViewControllerAnimated:YES];
//        }
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
                    [self.topicCommentArray removeAllObjects];
                    [self getTopicCommemtListDataWithPage:@1];
                    
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[FocusPersonCell class] forCellReuseIdentifier:NSStringFromClass([FocusPersonCell class])];
    
    UINib *nibHeaderCell = [UINib nibWithNibName:NSStringFromClass([TopicDetailHeaderCell class]) bundle:nil];
    [self.tableView registerNib:nibHeaderCell forCellReuseIdentifier:NSStringFromClass([TopicDetailHeaderCell class])];
    
//    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
//    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getTopicCommemtListDataWithPage:self.page];
    }];
}

#pragma mark - <跳转“好友详情”页面>
-(void)jumpToFocusPersonalVCWithUserID:(NSString *)user_id
{
    FocusPersonFileViewController *focusPersonalVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
    focusPersonalVC.friend_user_id = user_id;
    [self.navigationController pushViewController:focusPersonalVC animated:YES];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //点击“@人”好友主页
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToFocusPersonalVCByAtSomeoneFromTopicDetailVC" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *user_id = x.object;
        [self jumpToFocusPersonalVCWithUserID:user_id];
    }];
    
    //点击头像跳转好友主页
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToFocusPersonalVCByPortraitFromTopicDetail" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *user_id = x.object;
        [self jumpToFocusPersonalVCWithUserID:user_id];
    }];
    
    //点赞
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"likeByClickFromTopicDetail" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *talk_id = x.object;
        [self requestLikeOrCancelLikeWithTalkID:talk_id likeType:@"0"];
    }];
    
    //取消点赞
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"cancelLikeByClickFromTopicDetail" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *talk_id = x.object;
        [self requestLikeOrCancelLikeWithTalkID:talk_id likeType:@"1"];
    }];
    
}
















#pragma mark - **** UITableViewDelegate,UITableViewDataSource *****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.topicCommentArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        TopicDetailHeaderCell *cellHeader = [[TopicDetailHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TopicDetailHeaderCell class])];
//        cellHeader.modelResult = self.modelTopicDetailResult;
        return kSCREEN_WIDTH;
    }else{
        MyCircleDynamicResultModel *modelResult = self.topicCommentArray[indexPath.row];
        FocusPersonCell *cellDynamic = [[FocusPersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FocusPersonCell class])];
        cellDynamic.modelCircleDynamicResult = modelResult;
        return cellDynamic.cellHeight;
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        TopicDetailHeaderCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopicDetailHeaderCell class])];
        cellHeader.modelResult = self.modelTopicDetailResult;
        cell = cellHeader;
    }else{
        MyCircleDynamicResultModel *modelResult = self.topicCommentArray[indexPath.row];
        FocusPersonCell *cellDynamic = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FocusPersonCell class])];
        cellDynamic.modelCircleDynamicResult = modelResult;
        cellDynamic.whereFrom = @"topicDetail";
        cell = cellDynamic;
    }
    return cell;
}






@end
