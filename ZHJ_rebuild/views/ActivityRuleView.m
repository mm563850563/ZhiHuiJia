//
//  ActivityRuleView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ActivityRuleView.h"

@implementation ActivityRuleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btnCloseRuleViewAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"closeRuleViewAction" object:nil];
}

@end
