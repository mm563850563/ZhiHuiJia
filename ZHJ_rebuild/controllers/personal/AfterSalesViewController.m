//
//  AfterSalesViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "AfterSalesViewController.h"

//cells
#import "AfterSalesCell.h"

//views
#import "AfterSalesHeaderView.h"

//models
#import "AfterSaleListResultModel.h"
#import "AfterSaleListDataModel.h"

@interface AfterSalesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *afterSaleListArray;

@end

@implementation AfterSalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [self getAfterSaleListDataWithHUD:hud];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载> 
-(NSMutableArray *)afterSaleListArray
{
    if (!_afterSaleListArray) {
        _afterSaleListArray = [NSMutableArray array];
    }
    return _afterSaleListArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取售后服务列表>
-(void)getAfterSaleListDataWithHUD:(MBProgressHUD *)hud
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kReturnGoodsList];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = dataDict[@"code"];
            if ([code isEqual:@200]) {
                AfterSaleListDataModel *modelData = [[AfterSaleListDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.afterSaleListArray = [NSMutableArray arrayWithArray:modelData.result];
                //回到主线程刷新数据
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
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
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

#pragma mark - <初始化tableView>
-(void)initTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 100;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([AfterSalesCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([AfterSalesCell class])];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getAfterSaleListDataWithHUD:nil];
    }];
}














#pragma mark - **** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.afterSaleListArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    //    if (section == 4) {
//    //        return 100;
//    //    }
//    return 10;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AfterSalesHeaderView *headerView  = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([AfterSalesHeaderView class]) owner:nil options:nil].lastObject;
    AfterSaleListResultModel *modelAfterSaleResult = self.afterSaleListArray[section];
    headerView.modelAfterSaleResult = modelAfterSaleResult;
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AfterSalesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AfterSalesCell class])];
    AfterSaleListResultModel *modelAfterSaleResult = self.afterSaleListArray[indexPath.section];
    cell.modelAfterSaleResult = modelAfterSaleResult;
    return cell;
}

@end
