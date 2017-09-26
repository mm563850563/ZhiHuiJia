//
//  CircleDetailConfigViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/28.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CircleDetailConfigViewController.h"

//cells
#import "CircleDetailConfigItemCell.h"
#import "CircleDetailConfigQuitCell.h"

//controllers
#import "AllCircleMemberViewController.h"
#import "ReportTypeViewController.h"

//tools
#import "ShareTool.h"

//SDKs
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

@interface CircleDetailConfigViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CircleDetailConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"设置";
    [self settingTableView];
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


#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nibItem = [UINib nibWithNibName:NSStringFromClass([CircleDetailConfigItemCell class]) bundle:nil];
    [self.tableView registerNib:nibItem forCellReuseIdentifier:NSStringFromClass([CircleDetailConfigItemCell class])];
    
    UINib *nibQuit = [UINib nibWithNibName:NSStringFromClass([CircleDetailConfigQuitCell class]) bundle:nil];
    [self.tableView registerNib:nibQuit forCellReuseIdentifier:NSStringFromClass([CircleDetailConfigQuitCell class])];

}

#pragma mark - <跳转“查看所有成员”页面>
-(void)jumpToCheckAllMemberVCWithCircleID:(NSString *)circle_id
{
    AllCircleMemberViewController *allMemberVC = [[AllCircleMemberViewController alloc]initWithNibName:NSStringFromClass([AllCircleMemberViewController class]) bundle:nil];
    allMemberVC.circle_id = circle_id;
    [self.navigationController pushViewController:allMemberVC animated:YES];
}

#pragma mark - <跳转“举报”页面>
-(void)jumpToReportTypeVC
{
    ReportTypeViewController *reportTypeVC = [[ReportTypeViewController alloc]initWithNibName:NSStringFromClass([ReportTypeViewController class]) bundle:nil];
    reportTypeVC.hidesBottomBarWhenPushed = YES;
    reportTypeVC.navigationItem.title = @"选择举报类型";
    [self.navigationController pushViewController:reportTypeVC animated:YES];
}

#pragma mark - <"退出圈子"请求>
-(void)requestExitCircle
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kExitCircle];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"circle_id":self.circle_id};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    hud.completionBlock = ^{
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"exitCircleRefresh" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    };
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <第三方分享-配置要分享的参数>
-(void)settingShareParameter
{
    //1.创建分享参数 注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    UIImage *image = [UIImage imageNamed:@"appLogo"];
    NSArray *imageArray = @[image];
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"全球首个爆品推荐+智慧社交平台！1亿礼品库、注册必送礼！" images:imageArray url:[NSURL URLWithString:kZHJAppStoreLink] title:@"智惠加" type:SSDKContentTypeAuto];
        
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        //2.分享（可以弹出我们的分享菜单和编辑界面）
        [ShareTool shareWithParams:shareParams];
    }
}













#pragma mark - ***** UITableViewDelegate,UITableViewDataSource *****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 100;
    }else{
        return 60;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row == 3) {
        CircleDetailConfigQuitCell *cellQuit = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CircleDetailConfigQuitCell class])];
        cell = cellQuit;
    }else{
        CircleDetailConfigItemCell *cellNormalItem = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CircleDetailConfigItemCell class])];
        if (indexPath.row == 0) {
            cellNormalItem.labelTitle.text = @"分享圈子";
        }else if (indexPath.row == 1){
            cellNormalItem.labelTitle.text = @"查看全部圈子成员";
        }else if (indexPath.row == 2){
            cellNormalItem.labelTitle.text = @"举报";
        }
        cell = cellNormalItem;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self settingShareParameter];
    }else if (indexPath.row == 1){
        //查看全部成员
        [self jumpToCheckAllMemberVCWithCircleID:self.circle_id];
    }else if (indexPath.row == 2){
        //举报
        [self jumpToReportTypeVC];
    }else if (indexPath.row == 3){
        //退出圈子
        [self requestExitCircle];
    }
}



@end
