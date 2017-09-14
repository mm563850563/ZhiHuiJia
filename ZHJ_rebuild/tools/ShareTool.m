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

@implementation ShareTool

+(void)shareWithParams:(NSMutableDictionary *)params
{
    //2.分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil
                             items:@[@(SSDKPlatformSubTypeQQFriend),
                                     @(SSDKPlatformTypeSinaWeibo),
                                     @(SSDKPlatformSubTypeWechatSession),
                                     @(SSDKPlatformSubTypeWechatTimeline)]
                       shareParams:params
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
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

@end
