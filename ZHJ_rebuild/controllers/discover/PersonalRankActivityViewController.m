//
//  PersonalRankActivityViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "PersonalRankActivityViewController.h"

//cells
#import "ActivityRankFirstCell.h"
#import "PersonalActivityRankCell.h"

//views
//#import "PersonalActivityRankFooterView.h"

//controllers
#import "FocusPersonFileViewController.h"
#import "DisclaimerViewController.h"

//models
#import "PersonalLivenessRankDataModel.h"
#import "PersonalLivenessRankResultModel.h"
#import "PersonalLivenessRank_personal_rank_infoModel.h"
#import "PersonalLivenessRank_my_first_rank_infoModel.h"

@interface PersonalRankActivityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *labelMyRank;
@property (weak, nonatomic) IBOutlet UILabel *labelMyLiveness;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *rankListArray;

@property (nonatomic, strong)PersonalLivenessRankResultModel *modelResult;
@property (nonatomic, strong)NSNumber *page;

@end

@implementation PersonalRankActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = @1;
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [self getPersonalLivenessDataWithHUD:hud page:@1];
    [self settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)rankListArray
{
    if (!_rankListArray) {
        _rankListArray = [NSMutableArray array];
    }
    return _rankListArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

#pragma mark - <获取“排行榜”数据>
-(void)getPersonalLivenessDataWithHUD:(MBProgressHUD *)hud page:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kPersonalLivenessRank];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"page":page,
                                    @"page_count":@10};
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                PersonalLivenessRankDataModel *modelData = [[PersonalLivenessRankDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.modelResult = modelData.result;
//                self.modelChampion = self.modelResult.circle_rank_champion;
//                self.modelMyJoined = self.modelResult.my_first_rank_info;
                
                for (PersonalLivenessRank_personal_rank_infoModel *modelRankInfo in modelData.result.personal_rank_info) {
                    [self.rankListArray addObject:modelRankInfo];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self fillDataToOutletsWithModel:self.modelResult];
                    [self.tableView reloadData];
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView.mj_footer endRefreshing];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    [self.tableView.mj_footer endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                [self.tableView.mj_footer endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark - <填充数据>
-(void)fillDataToOutletsWithModel:(PersonalLivenessRankResultModel *)model
{
    PersonalLivenessRank_my_first_rank_infoModel *modelMyFirstRankInfo = model.my_first_rank_info;
    self.labelMyRank.text = [NSString stringWithFormat:@"%@",modelMyFirstRankInfo.rank];
    self.labelMyLiveness.text = [NSString stringWithFormat:@"%@点",modelMyFirstRankInfo.total_liveness];
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibFirst = [UINib nibWithNibName:NSStringFromClass([ActivityRankFirstCell class]) bundle:nil];
    [self.tableView registerNib:nibFirst forCellReuseIdentifier:NSStringFromClass([ActivityRankFirstCell class])];
    
    UINib *nibNormal = [UINib nibWithNibName:NSStringFromClass([PersonalActivityRankCell class]) bundle:nil];
    [self.tableView registerNib:nibNormal forCellReuseIdentifier:NSStringFromClass([PersonalActivityRankCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getPersonalLivenessDataWithHUD:nil page:self.page];
    }];
}

#pragma mark - <跳转“活跃度规则”页面>
-(void)jumpToPersonalActivitilyRuleVCWithDisclaimer:(NSString *)disclaimer
{
    DisclaimerViewController *disclaimerVC = [[DisclaimerViewController alloc]initWithNibName:NSStringFromClass([DisclaimerViewController class]) bundle:nil];
    disclaimerVC.disclaimer = disclaimer;
    [self.navigationController pushViewController:disclaimerVC animated:YES];
}

#pragma mark - <跳转“好友主页”>
-(void)jumpToFriendHomePageWithFriend_user_id:(NSString *)friend_user_id
{
    FocusPersonFileViewController *focusPersonFileVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
    focusPersonFileVC.friend_user_id = friend_user_id;
    [self.navigationController pushViewController:focusPersonFileVC animated:YES];
}










#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankListArray.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    PersonalActivityRankFooterView *footerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([PersonalActivityRankFooterView class]) owner:nil options:nil].lastObject;
//    footerView.modelMyFirstRankInfo = self.modelResult.my_first_rank_info;
//    return footerView;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row == 0) {
        ActivityRankFirstCell *cellFirst = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRankFirstCell class])];
        cellFirst.labelTitle.text = @"个人活跃度规则及奖励说明";
        cell = cellFirst;
        
    }else{
        PersonalActivityRankCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PersonalActivityRankCell class])];
        PersonalLivenessRank_personal_rank_infoModel *modelPersonalRank = self.rankListArray[indexPath.row-1];
        cellNormal.modelPersonalRank = modelPersonalRank;
        cell = cellNormal;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self jumpToPersonalActivitilyRuleVCWithDisclaimer:self.modelResult.personal_liveness_rule];
    }else{
        PersonalLivenessRank_personal_rank_infoModel *model = self.rankListArray[indexPath.row-1];
        [self jumpToFriendHomePageWithFriend_user_id:model.friend_user_id];
    }
}



@end
