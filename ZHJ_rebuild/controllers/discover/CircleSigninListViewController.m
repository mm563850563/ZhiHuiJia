//
//  CircleSigninListViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CircleSigninListViewController.h"

//models
#import "SigninListResultModel.h"
#import "SigninListDataModel.h"

//cells
#import "SigninListCell.h"
#import "NULLTableViewCell.h"

//controllers
#import "FocusPersonFileViewController.h"

@interface CircleSigninListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *signinListArray;
@property (nonatomic, strong)NSNumber *page;

@end

@implementation CircleSigninListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = @1;
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [self getSigninListWithHUD:hud page:self.page];
    [self settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)signinListArray
{
    if (!_signinListArray) {
        _signinListArray = [NSMutableArray array];
    }
    return _signinListArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <查看签到列表>
-(void)getSigninListWithHUD:(MBProgressHUD *)hud page:(NSNumber *)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetSignInList];
    NSDictionary *dictParameter = @{@"circle_id":self.circle_id,
                                    @"page":page,
                                    @"page_count":@10};
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                SigninListDataModel *modelData = [[SigninListDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                for (SigninListResultModel *modelResult in modelData.result) {
                    [self.signinListArray addObject:modelResult];
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

#pragma mark - <跳转“个人好友”资料>
-(void)jumpToFocusPersonalFileVCWithFriendUserID:(NSString *)friend_user_id
{
    FocusPersonFileViewController *focusPersonalFileVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
    focusPersonalFileVC.friend_user_id = friend_user_id;
    focusPersonalFileVC.whereReuseFrom = @"circleSigninListVC";
    [self.navigationController pushViewController:focusPersonalFileVC animated:YES];
}


#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
    UINib *nibSigninList = [UINib nibWithNibName:NSStringFromClass([SigninListCell class]) bundle:nil];
    [self.tableView registerNib:nibSigninList forCellReuseIdentifier:NSStringFromClass([SigninListCell class])];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int page = [self.page intValue];
        page++;
        self.page = [NSNumber numberWithInt:page];
        [self getSigninListWithHUD:nil page:self.page];
    }];
}
















#pragma mark - **** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.signinListArray.count == 0) {
        return 1;
    }
    return self.signinListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (self.signinListArray.count == 0) {
        NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        cell = cellNull;
    }else{
        SigninListCell *cellSignList = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SigninListCell class])];
        SigninListResultModel *modelResult = self.signinListArray[indexPath.row];
        cellSignList.modelSigninListResult = modelResult;
        cell = cellSignList;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.signinListArray.count == 0) {
        return self.view.frame.size.height;
    }
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SigninListResultModel *modelResult = self.signinListArray[indexPath.row];
    [self jumpToFocusPersonalFileVCWithFriendUserID:modelResult.user_id];
}







@end
