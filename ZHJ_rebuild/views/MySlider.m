//
//  MySlider.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/18.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MySlider.h"

@implementation MySlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, bounds.size.width, bounds.size.height);
}

//-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
//{
//    bounds = [super thumbRectForBounds:bounds trackRect:rect value:value]; // 这次如果不调用的父类的方法 Autolayout 倒是不会有问题，但是滑块根本就不动~
//    return CGRectMake(bounds.origin.x, bounds.origin.y, 50, 50); // w 和 h 是滑块可触摸范围的大小，跟通过图片改变的滑块大小应当一致。
//}

@end
