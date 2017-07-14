//
//  CALayer+XIBUIColor.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/14.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CALayer+XIBUIColor.h"

@implementation CALayer (XIBUIColor)

-(void)setBorderUIColor:(UIColor *)borderUIColor
{
    self.borderColor = borderUIColor.CGColor;
}

-(UIColor *)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
