//
//  DynamicDetailViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DynamicDetailViewController.h"

//tools
#import <IQKeyboardManager.h>

//cells
#import "DiscoverDynamicCell.h"
#import "PriaseTableViewCell.h"
#import "DynamicDetailCommentCell.h"

//models
#import "DynamicDetailDataModel.h"
#import "MyCircleDynamicResultModel.h"
#import "MyCircleDynamicTips_infoModel.h"
#import "DynamicDetailCommentDataModel.h"
#import "DynamicDetailCommentResultModel.h"

//controllers
#import "MyFocusViewController.h"

@interface DynamicDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfComment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *commentArray;

@property (nonatomic, strong)NSNumber *page;

@property (nonatomic, strong)MyCircleDynamicResultModel *modelResult;

//回复某人的user_id
@property (nonatomic, strong)NSString *at_user_id;

@end

@implementation DynamicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = @1;
    [self managerRequestWithGCD];
    [self settingOutlets];
    [self settingTableView];
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

#pragma mark - <懒加载>
-(NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
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
    dispatch_queue_t queue1 = dispatch_queue_create("getDynamicDetailData", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("getDynamicCommentData", NULL);
    
    dispatch_group_async(group, queue1, ^{
        [self getDynamicDetailData];
    });
    dispatch_group_async(group, queue2, ^{
        [self getDynamicDetailCommentDataWithPage:@1];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [hud hideAnimated:YES afterDelay:1.0];
    });
}

#pragma mark - <动态详情数据>
-(void)getDynamicDetailData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kNewsDetail];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"talk_id":self.talk_id};
    
    //    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                NSError *error = nil;
                DynamicDetailDataModel *modelData = [[DynamicDetailDataModel alloc]initWithDictionary:dataDict[@"data"] error:&error];
                self.modelResult = modelData.result;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <动态详情页面全部评论>
-(void)getDynamicDetailCommentDataWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetPostReview];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"talk_id":self.talk_id,
                                    @"page":page,
                                    @"page_count":@10};
    
    //    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                DynamicDetailCommentDataModel *modelData = [[DynamicDetailCommentDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                for (DynamicDetailCommentResultModel *modelDynamicResult in modelData.result) {
                    [self.commentArray addObject:modelDynamicResult];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    [self.tableView.mj_footer endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
                [self.tableView.mj_footer endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
            [self.tableView.mj_footer endRefreshing];
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
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDiscoverVCData" object:nil];
                    [self getDynamicDetailData];
                    
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

#pragma mark - <评论／回复评论>
-(void)requestCommentWithAtUserID:(NSString *)at_user_id content:(NSString *)content longitude:(NSString *)longitude latitude:(NSString *)latitude
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kAddReview];
    NSDictionary *dictParameter = [NSDictionary dictionary];
    if (at_user_id) {
        dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                          @"talk_id":self.talk_id,
                          @"at_user_id":at_user_id,
                          @"content":content};
//                @"longitude":@"34.8",
//                @"latitude":@"455.0"
    }else{
        dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                          @"talk_id":self.talk_id,
                          @"content":content};

//        @"longitude":@"34.8",
//        @"latitude":@"455.0"
    }

    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //评论成功后收回键盘
                    [self.tfComment resignFirstResponder];
                    self.tfComment.text = @"";
                    //清空数组，刷新评论列表
                    [self.commentArray removeAllObjects];
                    [self getDynamicDetailCommentDataWithPage:@1];
                    
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    [self.tableView.mj_footer endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
                [self.tableView.mj_footer endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
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
                    [self getDynamicDetailData];
                    
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

#pragma mark - <配置outlets>
-(void)settingOutlets
{
    self.tfComment.delegate = self;
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[DiscoverDynamicCell class] forCellReuseIdentifier:NSStringFromClass([DiscoverDynamicCell class])];
    
    UINib *nibPriase = [UINib nibWithNibName:NSStringFromClass([PriaseTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibPriase forCellReuseIdentifier:NSStringFromClass([PriaseTableViewCell class])];
    
    [self.tableView registerClass:[DynamicDetailCommentCell class] forCellReuseIdentifier:NSStringFromClass([DynamicDetailCommentCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getDynamicDetailCommentDataWithPage:self.page];
    }];
}

#pragma mark - <发送按钮响应>
- (IBAction)btnSendCommentAction:(UIButton *)sender
{
    if ([self.tfComment.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请填写评论内容"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else{
        [self requestCommentWithAtUserID:self.at_user_id content:self.tfComment.text longitude:nil latitude:nil];
    }
}


#pragma mark - <跳转“点赞列表”页面>
-(void)jumpToTalkLikeListVCWithTalkID:(NSString *)talk_id
{
    MyFocusViewController *talkLikeListVC = [[MyFocusViewController alloc]initWithNibName:NSStringFromClass([MyFocusViewController class]) bundle:nil];
    talkLikeListVC.talk_id = talk_id;
    [self.navigationController pushViewController:talkLikeListVC animated:YES];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //关注好友
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"attentionFriendByDynamicDetail" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *friend_user_id = x.object;
        [self attentionOrCancelAttentionWithFriendUserID:friend_user_id attentionType:@"1"];
    }];
    
    //取消关注好友
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"cancelAttentionFriendByDynamicDetail" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *friend_user_id = x.object;
        [self attentionOrCancelAttentionWithFriendUserID:friend_user_id attentionType:@"0"];
    }];
    
    //点赞
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"likeByClickFromDynamicDetail" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *talk_id = x.object;
        [self requestLikeOrCancelLikeWithTalkID:talk_id likeType:@"0"];
    }];
    
    //取消点赞
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"cancelLikeByClickFromDynamicDetail" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *talk_id = x.object;
        [self requestLikeOrCancelLikeWithTalkID:talk_id likeType:@"1"];
    }];
}








#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }else{
        return self.commentArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    if (indexPath.section == 0) {
        DiscoverDynamicCell *cell = [[DiscoverDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DiscoverDynamicCell class])];
        cell.modelCircleDynamicResult = self.modelResult;
        height = cell.cellHeight;
    }else if (indexPath.section == 1){
        height = 50;
    }else if (indexPath.section == 2){
        DynamicDetailCommentCell *cell = [[DynamicDetailCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DynamicDetailCommentCell class])];
        DynamicDetailCommentResultModel *modelResult = self.commentArray[indexPath.row];
        cell.modelDynamicCommentResult = modelResult;
        height = cell.cellHeight;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 10;
    if (section == 0) {
        height = 0.1f;
    }
    if (section == 2) {
        height = 35;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1f;
    if (section == 1) {
        height = 10;
    }
    if (section == 2) {
        height = 20;

    }
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
        headerView.backgroundColor = kColorFromRGB(kWhite);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, headerView.frame.size.width, headerView.frame.size.height)];
        [headerView addSubview:label];
        label.text = [NSString stringWithFormat:@"全部评论(%@)",self.modelResult.reply_count];
        label.font = [UIFont systemFontOfSize:13];
        
        UIView *line =[[ UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, headerView.frame.size.width, 0.5)];
        line.backgroundColor = kColorFromRGB( kLightGray);
        [headerView addSubview:line];
        return headerView;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        DiscoverDynamicCell *cell2 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DiscoverDynamicCell class])];
        cell2.whereReuseFrom = @"dynamicDetail";
        if (self.whereReuseFrom) {
            cell2.whereReuseFrom = self.whereReuseFrom;
        }
        cell2.modelCircleDynamicResult = self.modelResult;
        cell = cell2;
    }else if (indexPath.section == 1){
        PriaseTableViewCell *cellPriase = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PriaseTableViewCell class])];
        NSArray *likeArray = self.modelResult.like_info;
        cellPriase.likeArray = likeArray;
        cell = cellPriase;
    }else if (indexPath.section == 2){
        DynamicDetailCommentCell *cellComment = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DynamicDetailCommentCell class])];
        DynamicDetailCommentResultModel *modelResult = self.commentArray[indexPath.row];
        cellComment.whereReuseFrom = @"dynamicDetailVC";
        cellComment.modelDynamicCommentResult = modelResult;
        cell = cellComment;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1){
        if (self.modelResult.like_info.count > 0) {
            [self jumpToTalkLikeListVCWithTalkID:self.modelResult.talk_id];
        }
    }else if (indexPath.section == 2){
        DynamicDetailCommentResultModel *modelResult = self.commentArray[indexPath.row];
        self.at_user_id = modelResult.user_id;
        self.tfComment.placeholder = [NSString stringWithFormat:@"回复 %@:",modelResult.nickname];
        if (![self.tfComment isFirstResponder]) {
            [self.tfComment becomeFirstResponder];
        }
    }
}






#pragma mark - ******** UITextFieldDelegate ***********
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![[IQKeyboardManager sharedManager] isKeyboardShowing]) {
        textField.placeholder = @"说点什么吧";
    }
}








@end
