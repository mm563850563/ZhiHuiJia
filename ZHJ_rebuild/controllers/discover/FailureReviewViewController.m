//
//  FailureReviewViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "FailureReviewViewController.h"

//cells
#import "NULLTableViewCell.h"
#import "FailureReviewActivityCell.h"

//models
#import "RefuseActivityDataModel.h"
#import "RefuseActivityResultModel.h"

@interface FailureReviewViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *refuseActivityArray;

@property (nonatomic, strong)NSNumber *page;

@end

@implementation FailureReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = [NSNumber numberWithInt:1];
    [self getRefuseActivitiesData];
    [self settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)refuseActivityArray
{
    if (!_refuseActivityArray) {
        _refuseActivityArray = [NSMutableArray array];
    }
    return _refuseActivityArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <审核失败活动数据>
-(void)getRefuseActivitiesData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kRefuseActivity];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
//    NSDictionary *dictParameter = @{@"user_id":@"3553"};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                RefuseActivityDataModel *modelRefuseActivityData = [[RefuseActivityDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.refuseActivityArray = [NSMutableArray arrayWithArray:modelRefuseActivityData.result];
                
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

#pragma mark - <获取更多审核失败数据>
-(void)getMoreRefuseActivitiesDataWithPage:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kRefuseActivity];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"page":page,
                                    @"page_count":@10};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                RefuseActivityDataModel *modelRefuseActivityData = [[RefuseActivityDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                for (RefuseActivityResultModel *modelResult in modelRefuseActivityData.result) {
                    [self.refuseActivityArray addObject:modelResult];
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


#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([FailureReviewActivityCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([FailureReviewActivityCell class])];
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getMoreRefuseActivitiesDataWithPage:self.page];
    }];
}








#pragma mark - ***** UITableViewDelegate,UITableViewDataSource ******
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.refuseActivityArray.count == 0) {
        return 1;
    }
    return self.refuseActivityArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.refuseActivityArray.count == 0) {
        return self.view.frame.size.height;
    }
    return 100;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.refuseActivityArray.count == 0) {
        NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        return cellNull;
    }
    FailureReviewActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FailureReviewActivityCell class])];
    RefuseActivityResultModel *modelResult = self.refuseActivityArray[indexPath.row];
    cell.modelRefuseActivityResult = modelResult;
    return cell;
}




@end
