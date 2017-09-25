//
//  LogisticsViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "LogisticsViewController.h"

//cells
#import "LogisticsMessageCell.h"
#import "LogisticsRealTimeLatestCell.h"
#import "LogisticsNormalTableViewCell.h"

//models
#import "LogisticsRealTimeModel.h"
#import "LogisticsResultModel.h"
#import "LogisticsDataModel.h"

@interface LogisticsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *logisticsArray;

@property (nonatomic, strong)LogisticsResultModel *modelResult;

@end

@implementation LogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"查看物流";
    // Do any additional setup after loading the view from its nib.
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [self getLogisticsDataWithHUD:hud];
    [self settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)logisticsArray
{
    if (!_logisticsArray) {
        _logisticsArray = [NSMutableArray array];
    }
    return _logisticsArray;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取物流数据>
-(void)getLogisticsDataWithHUD:(MBProgressHUD *)hud
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kQueryExpress];
    
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"order_id":self.order_id};
    
    
    
    [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = dataDict[@"code"];
            if ([code isEqual:@200]) {
                LogisticsDataModel *modelData = [[LogisticsDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.modelResult = modelData.result;
                self.logisticsArray = [NSMutableArray arrayWithArray:self.modelResult.data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];

                    [self.tableView.mj_header endRefreshing];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
                [hudWarning hideAnimated:YES afterDelay:1.0];
                
                [self.tableView.mj_header endRefreshing];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
            
            [self.tableView.mj_header endRefreshing];
        });
    }];
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nibMessage = [UINib nibWithNibName:NSStringFromClass([LogisticsMessageCell class]) bundle:nil];
    [self.tableView registerNib:nibMessage forCellReuseIdentifier:NSStringFromClass([LogisticsMessageCell class])];
    
    UINib *nibLatest = [UINib nibWithNibName:NSStringFromClass([LogisticsRealTimeLatestCell class]) bundle:nil];
    [self.tableView registerNib:nibLatest forCellReuseIdentifier:NSStringFromClass([LogisticsRealTimeLatestCell class])];
    
    UINib *nibNormal = [UINib nibWithNibName:NSStringFromClass([LogisticsNormalTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNormal forCellReuseIdentifier:NSStringFromClass([LogisticsNormalTableViewCell class])];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getLogisticsDataWithHUD:nil];
    }];
}










#pragma mark - ****** UITableViewDelegate,UITableViewDataSource *******
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.logisticsArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            LogisticsRealTimeLatestCell *cellLatest = [[LogisticsRealTimeLatestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([LogisticsRealTimeLatestCell class])];
            LogisticsRealTimeModel *modelRealTime = self.logisticsArray[indexPath.row];
            cellLatest.modelRealTime = modelRealTime;
            return cellLatest.cellHeight;
        }else{
            LogisticsNormalTableViewCell *cellNormal = [[LogisticsNormalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([LogisticsNormalTableViewCell class])];
            LogisticsRealTimeModel *modelRealTime = self.logisticsArray[indexPath.row];
            cellNormal.modelRealTime = modelRealTime;
            return cellNormal.cellHeight;
        }
        
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        LogisticsMessageCell *cellMessage = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LogisticsMessageCell class])];
        cellMessage.modelLogisticsResult = self.modelResult;
        cell = cellMessage;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            LogisticsRealTimeLatestCell *cellLatest = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LogisticsRealTimeLatestCell class])];
            LogisticsRealTimeModel *modelRealTime = self.logisticsArray[indexPath.row];
            cellLatest.modelRealTime = modelRealTime;
            cell = cellLatest;
        }else{
            LogisticsNormalTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LogisticsNormalTableViewCell class])];
            LogisticsRealTimeModel *modelRealTime = self.logisticsArray[indexPath.row];
            cellNormal.modelRealTime = modelRealTime;
            cell = cellNormal;
        }
    }
    return cell;
}






@end
