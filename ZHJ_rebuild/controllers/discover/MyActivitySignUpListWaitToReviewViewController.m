//
//  MyActivitySignUpListWaitToReviewViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyActivitySignUpListWaitToReviewViewController.h"

//cells
#import "NULLTableViewCell.h"
#import "MyActivitySignUpListWaitReviewCell.h"

//models
#import "WaitAuditSignUpDataModel.h"
#import "WaitAuditSignUpResultModel.h"

@interface MyActivitySignUpListWaitToReviewViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *waitToReviewSignupArray;
@property (nonatomic, strong)NSNumber *page;

@end

@implementation MyActivitySignUpListWaitToReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = [NSNumber numberWithInt:1];
    [self getWaitAuditSignupData];
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
-(void)getWaitAuditSignupData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kWaitAuditSignUp];
    NSDictionary *dictParameter = @{@"activity_id":self.activity_id};
    
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


#pragma mark - <获取更多待审核活动数据>
-(void)getMoreWaitAuditActivitiesDataWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kWaitAuditSignUp];
    NSDictionary *dictParameter = @{@"activity_id":self.activity_id,
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

#pragma mark - <通过／拒绝用户报名活动>
-(void)getAuditSignUpDataWithAuditType:(NSString *)auditType signUpID:(NSString *)signUp_id
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kAuditSignUp];
    NSDictionary *dictParameter = @{@"signup_id":signUp_id,
                                    @"pass":auditType};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getWaitAuditSignupData];
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
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([MyActivitySignUpListWaitReviewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([MyActivitySignUpListWaitReviewCell class])];
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getMoreWaitAuditActivitiesDataWithPage:self.page];
    }];
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    //通过报名活动
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"passJoinTheActivity" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *signup_id = x.object;
        [self getAuditSignUpDataWithAuditType:@"1" signUpID:signup_id];
    }];
    
    //拒绝报名活动
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"refuseJoinTheActivity" object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *signup_id = x.object;
        [self getAuditSignUpDataWithAuditType:@"2" signUpID:signup_id];
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
    MyActivitySignUpListWaitReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyActivitySignUpListWaitReviewCell class])];
    WaitAuditSignUpResultModel *modelResult = self.waitToReviewSignupArray[indexPath.row];
    cell.modelWaitAuditSignUpResult = modelResult;
    return cell;
}



@end
