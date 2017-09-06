//
//  RankingListViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "RankingListViewController.h"

//cells
#import "ActivityRankFirstCell.h"
#import "ActivityRankNormalCell.h"

//models
#import "RankListDataModel.h"
#import "RankListResultModel.h"
#import "RankList_circle_rank_championModel.h"
#import "RankList_my_first_rank_infoModel.h"
#import "RankList_circle_rank_infoModel.h"

//controllers
#import "DisclaimerViewController.h"


@interface RankingListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *labelAnnounce;
@property (weak, nonatomic) IBOutlet UILabel *labelTotal_liveness;
@property (weak, nonatomic) IBOutlet UILabel *labelMyJoinedRank;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *rankListArray;

@property (nonatomic, strong)RankListResultModel *modelResult;
@property (nonatomic, strong)RankList_circle_rank_championModel *modelChampion;
@property (nonatomic, strong)RankList_my_first_rank_infoModel *modelMyJoined;

@property (nonatomic, strong)NSNumber *page;

@end

@implementation RankingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = @1;
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [self getRankListDataWithHUD:hud page:self.page];
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
-(void)getRankListDataWithHUD:(MBProgressHUD *)hud page:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kCircleLivenessRank];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"page":page,
                                    @"page_count":@10};
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                RankListDataModel *modelData = [[RankListDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.modelResult = modelData.result;
                self.modelChampion = self.modelResult.circle_rank_champion;
                self.modelMyJoined = self.modelResult.my_first_rank_info;
                
                for (RankList_circle_rank_infoModel *modelRankInfo in modelData.result.circle_rank_info) {
                    [self.rankListArray addObject:modelRankInfo];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self fillDataToOutletsWithModelResult:self.modelResult modelMyJoinedModel:self.modelMyJoined modelChampion:self.modelChampion];
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView reloadData];
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

#pragma mark - <填充页面数据>
-(void)fillDataToOutletsWithModelResult:(RankListResultModel *)modelResult modelMyJoinedModel:(RankList_my_first_rank_infoModel *)modelMyJoined modelChampion:(RankList_circle_rank_championModel *)modelChampion
{
    self.labelAnnounce.text = [NSString stringWithFormat:@"%@月份，每月1号重新计算排名，整点更新",modelResult.current_month];
    self.labelMyJoinedRank.text = [NSString stringWithFormat:@"你加入的圈子中活跃度排名最高为%@,排名第%@名",modelMyJoined.circle_name,modelMyJoined.rank];
    self.labelTotal_liveness.text = modelChampion.total_liveness;
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibFirst = [UINib nibWithNibName:NSStringFromClass([ActivityRankFirstCell class]) bundle:nil];
    [self.tableView registerNib:nibFirst forCellReuseIdentifier:NSStringFromClass([ActivityRankFirstCell class])];
    
    UINib *nibNormal = [UINib nibWithNibName:NSStringFromClass([ActivityRankNormalCell class]) bundle:nil];
    [self.tableView registerNib:nibNormal forCellReuseIdentifier:NSStringFromClass([ActivityRankNormalCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getRankListDataWithHUD:nil page:self.page];
    }];
}

#pragma mark - <跳转同城活动免责声明响应>
-(void)jumpToDisclaimerVCWithDisclaimer:(NSString *)disclaimer
{
    DisclaimerViewController *disclaimerVC = [[DisclaimerViewController alloc]initWithNibName:NSStringFromClass([DisclaimerViewController class]) bundle:nil];
    disclaimerVC.disclaimer = disclaimer;
    disclaimerVC.navigationItem.title = @"圈子活跃度规则";
    [self.navigationController pushViewController:disclaimerVC animated:YES];
}









#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankListArray.count;
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row == 0) {
        ActivityRankFirstCell *cellFirst = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRankFirstCell class])];
        cellFirst.labelTitle.text = @"圈子活跃度规则及奖励说明";
        cell = cellFirst;
        
    }else{
        ActivityRankNormalCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRankNormalCell class])];
        RankList_circle_rank_infoModel *modelRankInfo = self.rankListArray[indexPath.row];
        cellNormal.modelRankInfo = modelRankInfo;
        cell = cellNormal;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self jumpToDisclaimerVCWithDisclaimer:self.modelResult.circle_liveness_rule];
    }else{
        
    }
}





@end
