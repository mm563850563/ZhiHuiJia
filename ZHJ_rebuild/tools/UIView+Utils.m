//
//  UIView+Utils.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/14.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (UIView*)subViewOfClassName:(NSString*)className
{
    for (UIView* subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }
        
        UIView* resultFound = [subView subViewOfClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}

@end
