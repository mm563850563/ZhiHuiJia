//
//  ShakeChanceAfterShare.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ShakeChanceAfterShare.h"

@implementation ShakeChanceAfterShare

#pragma mark - <分享成功后获得摇一摇机会>
+(void)getShakeChanceAfterShare
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetChanceByShare];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
    
    [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = dataDict[@"code"];
            if ([code isEqual:@200]) {
                //回到主线程刷新数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@",dataDict[@"msg"]);
                });
            }
        }
    } failBlock:^(NSError *error) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
        //            [hudWarning hideAnimated:YES afterDelay:1.0];
        //        });
        NSLog(@"%@",error);
    }];
}

@end
