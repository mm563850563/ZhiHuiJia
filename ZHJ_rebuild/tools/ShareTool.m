//
//  ShareTool.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/14.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ShareTool.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
// 自定义分享编辑界面所需要导入的头文件
#import <ShareSDKUI/SSUIEditorViewStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>

#import "ShakeChanceAfterShare.h"




//@interface ShareTool ()<UIAlertViewDelegate>{
//    UIAlertView *alertSuccess;
//}
//
//@end

@implementation ShareTool

+(void)shareWithParams:(NSMutableDictionary *)params
{
    [SSUIShareActionSheetStyle isCancelButtomHidden:YES];
    
    //2.分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil
                             items:@[@(SSDKPlatformTypeSinaWeibo),
                                     @(SSDKPlatformSubTypeWechatSession),
                                     @(SSDKPlatformSubTypeWechatTimeline),
                                     @(SSDKPlatformSubTypeQQFriend)]
                       shareParams:params
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           //分享成功后获得摇一摇机会
                           //http://www.havshark.com/api/User/getChanceByShare
                           [ShakeChanceAfterShare getShakeChanceAfterShare];
                           
                           UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
//                           alertSuccess.delegate = self;
                           [alertSuccess show];
                           break;
                       }
                           
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                           
                       default:
                           break;
                   }
               }];
}

//#pragma mark - <分享成功后获得摇一摇机会>
//-(void)getShakeChanceAfterShare
//{
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetChanceByShare];
//    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
//    
//    [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
//        if (response) {
//            NSDictionary *dataDict = (NSDictionary *)response;
//            NSNumber *code = dataDict[@"code"];
//            if ([code isEqual:@200]) {
//                //回到主线程刷新数据
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                });
//            }
//        }
//    } failBlock:^(NSError *error) {
////        dispatch_async(dispatch_get_main_queue(), ^{
////            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
////            [hudWarning hideAnimated:YES afterDelay:1.0];
////        });
//        NSLog(@"%@",error);
//    }];
//}










//#pragma mark - ******UIAlertViewDelegate********
//-(void)willPresentAlertView:(UIAlertView *)alertView
//{
//    if (alertView == alertSuccess) {
//        [self getShakeChanceAfterShare];
//    }
//}

@end
