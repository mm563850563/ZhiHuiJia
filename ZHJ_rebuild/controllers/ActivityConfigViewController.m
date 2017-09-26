//
//  ActivityConfigViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ActivityConfigViewController.h"

//tools
#import "ShareTool.h"

//SDKs
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

//controllers
#import "ReportTypeViewController.h"

@interface ActivityConfigViewController ()

@end

@implementation ActivityConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingNavigationBar];
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

#pragma mark - <配置navigationBar>
-(void)settingNavigationBar
{
    self.navigationItem.title = @"设置";
}

#pragma mark - <分享按钮响应>
- (IBAction)btnShareAction:(UIButton *)sender
{
    [self settingShareParameter];
}

#pragma mark - <举报按钮响应>
- (IBAction)btnReportAction:(UIButton *)sender
{
    ReportTypeViewController *reportTypeVC = [[ReportTypeViewController alloc]initWithNibName:NSStringFromClass([ReportTypeViewController class]) bundle:nil];
    reportTypeVC.hidesBottomBarWhenPushed = YES;
    reportTypeVC.navigationItem.title = @"选择举报类型";
    [self.navigationController pushViewController:reportTypeVC animated:YES];
}

#pragma mark - <退出活动>
- (IBAction)btnCancelActivityAction:(UIButton *)sender
{
    [self getCancelActivityData];
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
//                    [self getActivityDetailData];
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    hudWarning.completionBlock = ^{
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"signedForActivity" object:nil];
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
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
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

@end
