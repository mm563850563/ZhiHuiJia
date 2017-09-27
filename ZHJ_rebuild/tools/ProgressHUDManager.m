//
//  ProgressHUDManager.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ProgressHUDManager.h"
#import <MBProgressHUD.h>

@implementation ProgressHUDManager

+(MBProgressHUD *)showProgressHUDAddTo:(UIView *)view animated:(BOOL)isAnimated 
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:isAnimated];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:1.0 alpha:0];
    return hud;
}

+(MBProgressHUD *)showReloadProgressHUD:(UIView *)view animated:(BOOL)isAnimated addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)events
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:isAnimated];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"请检查网络,重新加载";
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:1.0 alpha:1.0];
    [hud.button addTarget:target action:action forControlEvents:events];
    return hud;
}

+(MBProgressHUD *)showWarningProgressHUDAddTo:(UIView *)view animated:(BOOL)isAnimated warningMessage:(NSString *)warningMessage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:isAnimated];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = warningMessage;
    hud.label.numberOfLines = 0;
    hud.label.textColor = kColorFromRGB(kWhite);
    [hud setYOffset:230];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
//    [hud hideAnimated:YES afterDelay:1.0];
    return hud;
}

+(MBProgressHUD *)showFullScreenProgressHUDAddTo:(UIView *)view animated:(BOOL)isAnimated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:isAnimated];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.backgroundView.backgroundColor = kColorFromRGB(kWhite);
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:1.0 alpha:0];
    return hud;
}

@end
