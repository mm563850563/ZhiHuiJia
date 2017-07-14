//
//  UIImage+Color.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/7.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+(UIImage *)imageWithColor:(UIColor *)color
{
    //描述矩形
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    //开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    
    //获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    //渲染上下文
    CGContextFillRect(context, rect);
    
    //从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
