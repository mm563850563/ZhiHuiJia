//
//  SearchNetTool.m

#import "SearchNetTool.h"
#import <AFNetworking.h>
@implementation SearchNetTool
+ (void)searchNet{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    //2.开启监听
    [netManager startMonitoring];
    //3.监听改变
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"自带网络");
                break;

            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"没有网络");

//                UIAlertController *alertNetSeach = [UIAlertController alertControllerWithTitle:nil message:@"请检查网络设置" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//                [alertNetSeach addAction:actionConfirm];
//                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertNetSeach animated:YES completion:nil
//                ];
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
                break;
                
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
                
            default:
                break;
        }
    }];
    
    [netManager stopMonitoring];
}




+ (void)stopSearch{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}


@end
