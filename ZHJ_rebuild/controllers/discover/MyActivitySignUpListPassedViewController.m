//
//  MyActivitySignUpListPassedViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyActivitySignUpListPassedViewController.h"

//cells
#import "NULLTableViewCell.h"
#import "MyActivitySignUpListPassedCell.h"

//models
#import "WaitAuditSignUpDataModel.h"
#import "WaitAuditSignUpResultModel.h"

@interface MyActivitySignUpListPassedViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *waitToReviewSignupArray;
@property (nonatomic, strong)NSNumber *page;

@end

@implementation MyActivitySignUpListPassedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = [NSNumber numberWithInt:1];
    [self getPassedAuditSignupData];
    [self settingTableView];
    
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

#pragma mark - <待审核参加活动成员>
-(void)getPassedAuditSignupData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kPassAuditSignUp];
    NSDictionary *dictParameter = @{@"activity_id":self.activity_id,
                                    @"user_id":kUserDefaultObject(kUserInfo)};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                WaitAuditSignUpDataModel *modelWaitReviewSignupData = [[WaitAuditSignUpDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.waitToReviewSignupArray = [NSMutableArray arrayWithArray:modelWaitReviewSignupData.result];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView reloadData];
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


#pragma mark - <获取更多已通过的报名活动的用户数据>
-(void)getMorePassedAuditSignupDataWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kPassAuditSignUp];
    NSDictionary *dictParameter = @{@"activity_id":self.activity_id,
                                    @"user_id":kUserDefaultObject(kUserInfo),
                                    @"page":page,
                                    @"page_count":@10};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                WaitAuditSignUpDataModel *modelWaitReviewSignupData = [[WaitAuditSignUpDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                for (WaitAuditSignUpResultModel *modelResult in modelWaitReviewSignupData.result) {
                    [self.waitToReviewSignupArray addObject:modelResult];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
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
                    [self getPassedAuditSignupData];
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


#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([MyActivitySignUpListPassedCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([MyActivitySignUpListPassedCell class])];
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getMorePassedAuditSignupDataWithPage:self.page];
    }];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //关注好友
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"attentionFriend" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *friend_user_id = x.object;
        [self attentionOrCancelAttentionWithFriendUserID:friend_user_id attentionType:@"1"];
    }];
    
    //取消关注好友
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"cancelAttention" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *friend_user_id = x.object;
        [self attentionOrCancelAttentionWithFriendUserID:friend_user_id attentionType:@"0"];
    }];
    
}


















#pragma mark - ***** UITableViewDelegate,UITableViewDataSource ******
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.waitToReviewSignupArray.count == 0) {
        return 1;
    }
    return self.waitToReviewSignupArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.waitToReviewSignupArray.count == 0) {
        return self.view.frame.size.height;
    }
    return 100;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.waitToReviewSignupArray.count == 0) {
        NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        return cellNull;
    }
    MyActivitySignUpListPassedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyActivitySignUpListPassedCell class])];
    WaitAuditSignUpResultModel *modelResult = self.waitToReviewSignupArray[indexPath.row];
    cell.modelWaitAuditSignUpResult = modelResult;
    return cell;
}







@end
