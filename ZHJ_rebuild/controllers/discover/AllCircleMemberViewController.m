//
//  AllCircleMemberViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "AllCircleMemberViewController.h"

//cells
#import "AllCircleMemberListCell.h"

//models
#import "AllCircleMemberResultModel.h"
#import "AllCircleMemberDataModel.h"

//controllers
#import "FocusPersonFileViewController.h"

@interface AllCircleMemberViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *allMemberListArray;

@property (nonatomic, strong)NSNumber *page;

@end

@implementation AllCircleMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = @1;
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [self getAllMemberListDataWithHUD:hud page:self.page];
    [self settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <懒加载>
-(NSMutableArray *)allMemberListArray
{
    if (!_allMemberListArray) {
        _allMemberListArray = [NSMutableArray array];
    }
    return _allMemberListArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取“所有圈子成员”数据>
-(void)getAllMemberListDataWithHUD:(MBProgressHUD *)hud page:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kAllCircleMember];
    NSDictionary *dictParameter = @{@"circle_id":self.circle_id,
                                    @"user_id":kUserDefaultObject(kUserInfo),
                                    @"page":page,
                                    @"page_count":@10};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                AllCircleMemberDataModel *modelData = [[AllCircleMemberDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                for (AllCircleMemberResultModel *modelResult in modelData.result) {
                    [self.allMemberListArray addObject:modelResult];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
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

#pragma mark - <跳转“个人好友”资料>
-(void)jumpToFocusPersonalFileVC
{
    FocusPersonFileViewController *focusPersonalFileVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
    [self.navigationController pushViewController:focusPersonalFileVC animated:YES];
}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([AllCircleMemberListCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([AllCircleMemberListCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getAllMemberListDataWithHUD:nil page:self.page];
    }];
}












#pragma mark - **** UITableViewDelegate,UITableViewDataSource *****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allMemberListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllCircleMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AllCircleMemberListCell class])];
    AllCircleMemberResultModel *modelResult = self.allMemberListArray[indexPath.row];
    cell.modelCircleMemberResult = modelResult;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self jumpToFocusPersonalFileVC];
}




@end
