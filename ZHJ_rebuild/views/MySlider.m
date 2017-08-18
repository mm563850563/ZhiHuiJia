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

@end
