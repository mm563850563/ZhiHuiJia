//
//  ProgressHUDManager.h
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MBProgressHUD;

@interface ProgressHUDManager : NSObject

//@property (nonatomic, strong)MBProgressHUD *hud;

+(MBProgressHUD *)showProgressHUDAddTo:(UIView *)view animated:(BOOL)isAnimated;
+(MBProgressHUD *)showReloadProgressHUD:(UIView *)view animated:(BOOL)isAnimated addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)events;
+(MBProgressHUD *)showWarningProgressHUDAddTo:(UIView *)view animated:(BOOL)isAnimated warningMessage:(NSString *)warningMessage;

@end
