//
//  DomainHeaderView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DomainHeaderView.h"

@implementation DomainHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (IBAction)btnBackAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backToDiscover" object:nil];
}

- (IBAction)btnMessageAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToMessage" object:nil];
}

- (IBAction)btnEditAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToEdit" object:nil];
}

- (IBAction)btnFocusAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToMyFocus" object:nil];
}

- (IBAction)btnFansAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToMyFans" object:nil];
}

- (IBAction)btnMyActivitiesAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToMyActivities" object:nil];
}

- (IBAction)btnJoinedActivities:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToJoinedActivities" object:nil];
}

- (IBAction)btnRankActivityAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToRankActivity" object:nil];
}

- (IBAction)btnReleaseDynamicAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToRelease" object:nil];
}


@end
