//
//  ActivityRecommendDetailViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ActivityRecommendDetailViewController.h"

//cells
#import "ActivityRecommendImageCell.h"
#import "ActivityRecommendInformationCell.h"
#import "ActivityRecommendDetailCell.h"
#import "ActivityRecommendApplyCell.h"

//controllers
#import "ActivityApplyViewController.h"
#import "DisclaimerViewController.h"
#import "FocusPersonFileViewController.h"

//models
#import "ActivityDetailResultModel.h"
#import "ActivitySignUpListDataModel.h"
#import "ActivitySignUpListResultModel.h"

@interface ActivityRecommendDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)UIView *footerView;
@property (nonatomic, strong)ActivityDetailResultModel *model;
@property (nonatomic, strong)NSMutableArray *signupListArray;

@property (nonatomic, strong)NSNumber *page;

@end

@implementation ActivityRecommendDetailViewController

#pragma mark - <懒加载>
-(NSMutableArray *)signupListArray
{
    if (!_signupListArray) {
        _signupListArray = [NSMutableArray array];
    }
    return _signupListArray;
}

-(UIView *)footerView
{
    if (!_footerView) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 80)];
        //没有更多数据
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
        label.text = @"没有更多数据";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = kColorFromRGB(kDeepGray);
        [footerView addSubview:label];
        
        //同城活动免责声明
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, footerView.frame.size.height-40, kSCREEN_WIDTH, 40);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"同城活动免责声明"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [button setAttributedTitle:str forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [footerView addSubview:button];
        
        //button添加事件
        [button addTarget:self action:@selector(jumpToDisclaimerVC) forControlEvents:UIControlEventTouchUpInside];
        
        _footerView = footerView;
    }
    return _footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = [NSNumber numberWithInt:1];
    [self managerRequestWithGCD];
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

#pragma mark - <GCD多线程管理任务>
-(void)managerRequestWithGCD
{
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue1 = dispatch_queue_create("getActivityDetailData", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("getActivitySignUpListData", NULL);
    
    dispatch_group_async(group, queue1, ^{
        [self getActivityDetailData];
    });
    dispatch_group_async(group, queue2, ^{
        [self getSignUpListData];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [hud hideAnimated:YES afterDelay:1.0];
    });
}

#pragma mark - <获取活动详情数据>
-(void)getActivityDetailData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kActivityDetail];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"activity_id":self.activity_id};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                self.model = [[ActivityDetailResultModel alloc]initWithDictionary:dataDict[@"data"][@"result"] error:nil];
                
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

#pragma mark - <获取报名列表数据>
-(void)getSignUpListData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetSignUpList];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"activity_id":self.activity_id};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                ActivitySignUpListDataModel *modelSignUpListData = [[ActivitySignUpListDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.signupListArray = [NSMutableArray arrayWithArray:modelSignUpListData.result];
                
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

#pragma mark - <获取更多报名列表数据>
-(void)getMoreSignUpListDataWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetSignUpList];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"activity_id":self.activity_id,
                                    @"page":page,
                                    @"page_count":@10};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                ActivitySignUpListDataModel *modelSignUpListData = [[ActivitySignUpListDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                for (ActivitySignUpListResultModel *modelResult in modelSignUpListData.result) {
                    [self.signupListArray addObject:modelResult];
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
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
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
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibImageCell = [UINib nibWithNibName:NSStringFromClass([ActivityRecommendImageCell class]) bundle:nil];
    [self.tableView registerNib:nibImageCell forCellReuseIdentifier:NSStringFromClass([ActivityRecommendImageCell class])];
    
    UINib *nibInfomation = [UINib nibWithNibName:NSStringFromClass([ActivityRecommendInformationCell class]) bundle:nil];
    [self.tableView registerNib:nibInfomation forCellReuseIdentifier:NSStringFromClass([ActivityRecommendInformationCell class])];
    
    UINib *nibDetail = [UINib nibWithNibName:NSStringFromClass([ActivityRecommendDetailCell class]) bundle:nil];
    [self.tableView registerNib:nibDetail forCellReuseIdentifier:NSStringFromClass([ActivityRecommendDetailCell class])];
    
    UINib *nibApply = [UINib nibWithNibName:NSStringFromClass([ActivityRecommendApplyCell class]) bundle:nil];
    [self.tableView registerNib:nibApply forCellReuseIdentifier:NSStringFromClass([ActivityRecommendApplyCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getMoreSignUpListDataWithPage:self.page];
    }];
}

#pragma mark - <跳转同城活动免责声明响应>
-(void)jumpToDisclaimerVC
{
    DisclaimerViewController *disclaimerVC = [[DisclaimerViewController alloc]initWithNibName:NSStringFromClass([DisclaimerViewController class]) bundle:nil];
    disclaimerVC.disclaimer = self.model.disclaimer;
    [self.navigationController pushViewController:disclaimerVC animated:YES];
}
#pragma mark - <跳转报名页面>
-(void)jumpToApplyVCWithActivityID:(NSString *)activity_id disclaimer:(NSString *)disclaimer
{
    ActivityApplyViewController *applyVC = [[ActivityApplyViewController alloc]initWithNibName:NSStringFromClass([ActivityApplyViewController class]) bundle:nil];
    applyVC.activity_id = activity_id;
    applyVC.disclaimer = disclaimer;
    [self.navigationController pushViewController:applyVC animated:YES];
}
#pragma mark - <跳转个人页面>
-(void)jumpToPersonalFileVCWithFriendUserID:(NSString *)friend_user_id
{
    FocusPersonFileViewController *personalFileVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
    personalFileVC.friend_user_id = friend_user_id;
    personalFileVC.whereReuseFrom = @"activityRecommendDetailVC";
    [self.navigationController pushViewController:personalFileVC animated:YES];
}

#pragma mark - <取消报名>
-(void)getCancelActivityData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kCancelActivity];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"activity_id":self.activity_id};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getActivityDetailData];
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
                    [self getSignUpListData];
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


#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    //报名活动
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"applyAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UIButton *button = x.object;
        if (!button.selected) {
            [self jumpToApplyVCWithActivityID:self.model.activity_id disclaimer:self.model.disclaimer];
        }else{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"要取消报名？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self getCancelActivityData];
            }];
            UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertVC addAction:actionNO];
            [alertVC addAction:actionYES];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        
    }];
    
    //报名成功后
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"signedForActivity" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        
        [self getActivityDetailData];
    }];
    
    //关注好友
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"attentionFriend_activityDetail" object:nil] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *friend_user_id = x.object;
        [self attentionOrCancelAttentionWithFriendUserID:friend_user_id attentionType:@"1"];
    }];
    
    //取消关注好友
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"cancelAttention_activityDetail" object:nil] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *friend_user_id = x.object;
        [self attentionOrCancelAttentionWithFriendUserID:friend_user_id attentionType:@"0"];
    }];
}









#pragma mark - <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }else if (section == 3) {
        return self.signupListArray.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 80;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 30;
    }
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    headerView.backgroundColor = kColorFromRGB(kWhite);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, headerView.frame.size.width, headerView.frame.size.height)];
    label.text = [NSString stringWithFormat:@"报名列表（%lu）",(unsigned long)self.signupListArray.count];
    label.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:label];
    if (section == 3) {
        return headerView;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return self.footerView;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        ActivityRecommendImageCell *cellImage = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRecommendImageCell class])];
        cellImage.labelActivityTitle.text= self.model.title;
        cellImage.imgStr = self.model.image;
        if ([self.model.is_signup isEqualToString:@"1"]) {
            cellImage.btnApplyActivity.selected = YES;
        }else{
            cellImage.btnApplyActivity.selected = NO;
        }
        cell = cellImage;
    }else if (indexPath.section == 1){
        ActivityRecommendInformationCell *cellInfomatiom = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRecommendInformationCell class])];
        NSString *strTitle;
        NSString *strContent;
        if (indexPath.row == 0) {
            strTitle = @"活动地点：";
            strContent = self.model.location;
        }else if (indexPath.row == 1){
            strTitle = @"活动时间：";
            NSInteger t1 = [self.model.start_time integerValue];
            NSInteger t2 = [self.model.end_time integerValue];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy年MM月dd日"];
            NSDate *dateStart = [NSDate dateWithTimeIntervalSince1970:t1];
            NSDate *dataEnd = [NSDate dateWithTimeIntervalSince1970:t2];
            NSString *timeStart = [formatter stringFromDate:dateStart];
            NSString *timeEnd = [formatter stringFromDate:dataEnd];
            
            strContent = [NSString stringWithFormat:@"%@-%@",timeStart,timeEnd];
        }else if (indexPath.row == 2){
            strTitle = @"发起人：";
            strContent = self.model.initiator;
        }else if (indexPath.row == 3){
            strTitle = @"联系方式：";
            strContent = self.model.mobile;
        }else if (indexPath.row == 4){
            strTitle = @"活动费用：";
            strContent = self.model.entry_fee;
        }
        cellInfomatiom.labelTitle.text = strTitle;
        cellInfomatiom.labelContent .text = strContent;
        cell = cellInfomatiom;
    }else if (indexPath.section == 2){
        ActivityRecommendDetailCell *cellDetail = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRecommendDetailCell class])];
        cellDetail.labelDetail.text = self.model.content;
        cell = cellDetail;
    }else if (indexPath.section == 3){
        ActivityRecommendApplyCell *cellApply = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRecommendApplyCell class])];
        ActivitySignUpListResultModel *modelSignUpList = self.signupListArray[indexPath.row];
        cellApply.modelSignUpList = modelSignUpList;
        cell = cellApply;
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        ActivitySignUpListResultModel *modelSignUpList = self.signupListArray[indexPath.row];
        [self jumpToPersonalFileVCWithFriendUserID:modelSignUpList.friend_user_id];
    }
}


@end
